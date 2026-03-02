import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:production_authentication_app/core/error/exceptions.dart';
import 'package:production_authentication_app/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
    required String currentDeviceSerial,
  });

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String currentDeviceSerial,
  });

  Future<void> logout();

  Future<void> sendEmailVerification();

  Future<bool> checkEmailVerified();

  Future<String> refreshAuthToken();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  @override
  Future<UserModel> login({
    required String email,
    required String password,
    required String currentDeviceSerial,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const ServerException('Unable to retrieve authenticated user.');
      }

      await refreshAuthToken();

      final user = await _resolveAndValidateUser(
        uid: firebaseUser.uid,
        fallbackEmail: firebaseUser.email ?? email,
        isEmailVerified: firebaseUser.emailVerified,
        currentDeviceSerial: currentDeviceSerial,
      );

      return user;
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapFirebaseAuthCodeToMessage(e.code));
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to login.');
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String currentDeviceSerial,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const ServerException('Unable to create user account.');
      }

      final model = UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? email,
        role: 'user',
        deviceSerial: currentDeviceSerial,
        isEmailVerified: firebaseUser.emailVerified,
      );

      await _users.doc(model.uid).set({
        ...model.toFirestore(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return model;
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapFirebaseAuthCodeToMessage(e.code));
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to create account.');
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const ServerException('No authenticated user found.');
    }

    if (user.emailVerified) {
      return;
    }

    await user.sendEmailVerification();
  }

  @override
  Future<bool> checkEmailVerified() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const ServerException('No authenticated user found.');
    }

    await user.reload();
    return _firebaseAuth.currentUser?.emailVerified ?? false;
  }

  @override
  Future<String> refreshAuthToken() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const ServerException('No authenticated user found.');
    }

    try {
      return await user.getIdToken(true) ?? '';
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapFirebaseAuthCodeToMessage(e.code));
    }
  }

  Future<UserModel> _resolveAndValidateUser({
    required String uid,
    required String fallbackEmail,
    required bool isEmailVerified,
    required String currentDeviceSerial,
  }) async {
    final doc = await _users.doc(uid).get();

    if (!doc.exists) {
      final seeded = UserModel(
        uid: uid,
        email: fallbackEmail,
        role: 'user',
        deviceSerial: currentDeviceSerial,
        isEmailVerified: isEmailVerified,
      );

      await _users.doc(uid).set({
        ...seeded.toFirestore(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return seeded;
    }

    final user = UserModel.fromFirestore(doc, isEmailVerified);

    if (user.role != 'admin' && user.role != 'user') {
      throw const UnauthorizedRoleException('Invalid role assigned to account.');
    }

    if (user.deviceSerial.isEmpty) {
      await _users.doc(uid).update({
        'deviceSerial': currentDeviceSerial,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return UserModel(
        uid: user.uid,
        email: user.email,
        role: user.role,
        deviceSerial: currentDeviceSerial,
        isEmailVerified: user.isEmailVerified,
      );
    }

    if (user.deviceSerial != currentDeviceSerial) {
      throw const DeviceBindingException(
        'This account is bound to another device. Contact support.',
      );
    }

    return user;
  }

  String _mapFirebaseAuthCodeToMessage(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Invalid email or password.';
      case 'invalid-email':
        return 'Email format is invalid.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password must be at least 6 characters long.';
      case 'network-request-failed':
        return 'Network issue detected. Please try again.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait and retry.';
      case 'user-token-expired':
        return 'Session expired. Please sign in again.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
