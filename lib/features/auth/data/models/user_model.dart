import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:production_authentication_app/features/auth/domain/entities/app_user.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.uid,
    required super.email,
    required super.role,
    required super.deviceSerial,
    required super.isEmailVerified,
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    bool isEmailVerified,
  ) {
    final data = doc.data() ?? <String, dynamic>{};

    return UserModel(
      uid: doc.id,
      email: (data['email'] as String?) ?? '',
      role: ((data['role'] as String?) ?? 'user').toLowerCase(),
      deviceSerial: (data['deviceSerial'] as String?) ?? '',
      isEmailVerified: isEmailVerified,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'role': role,
      'deviceSerial': deviceSerial,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
