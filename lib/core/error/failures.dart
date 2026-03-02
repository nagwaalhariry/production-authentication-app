import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class DeviceBindingFailure extends Failure {
  const DeviceBindingFailure(super.message);
}

class UnauthorizedRoleFailure extends Failure {
  const UnauthorizedRoleFailure(super.message);
}
