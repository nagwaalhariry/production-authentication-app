import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String uid;
  final String email;
  final String role;
  final String deviceSerial;
  final bool isEmailVerified;

  const AppUser({
    required this.uid,
    required this.email,
    required this.role,
    required this.deviceSerial,
    required this.isEmailVerified,
  });

  bool get isAdmin => role.toLowerCase() == 'admin';

  @override
  List<Object?> get props => [uid, email, role, deviceSerial, isEmailVerified];
}
