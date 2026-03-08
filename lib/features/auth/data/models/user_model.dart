import 'package:production_authentication_app/features/auth/domain/entities/app_user.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.uid,
    required super.email,
    required super.role,
    required super.deviceSerial,
    required super.isEmailVerified,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: (data['uid'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
      role: ((data['role'] as String?) ?? 'user').toLowerCase(),
      deviceSerial: (data['deviceSerial'] as String?) ?? '',
      isEmailVerified: (data['isEmailVerified'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'deviceSerial': deviceSerial,
      'isEmailVerified': isEmailVerified,
    };
  }
}
