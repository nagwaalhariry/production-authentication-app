class ServerException implements Exception {
  final String message;

  const ServerException(this.message);
}

class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);
}

class DeviceBindingException implements Exception {
  final String message;

  const DeviceBindingException(this.message);
}

class UnauthorizedRoleException implements Exception {
  final String message;

  const UnauthorizedRoleException(this.message);
}
