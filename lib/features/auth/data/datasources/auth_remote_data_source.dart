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
  // In-memory auth store used after removing Firebase integration.
  static final Map<String, _LocalAccount> _accountsByEmail = {};
  static String? _activeEmail;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
    required String currentDeviceSerial,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final account = _accountsByEmail[normalizedEmail];
    if (account == null || account.password != password) {
      throw const ServerException('Invalid email or password.');
    }

    if (account.user.role != 'admin' && account.user.role != 'user') {
      throw const UnauthorizedRoleException('Invalid role assigned to account.');
    }

    if (account.deviceSerial.isEmpty) {
      account.deviceSerial = currentDeviceSerial;
    } else if (account.deviceSerial != currentDeviceSerial) {
      throw const DeviceBindingException(
        'This account is bound to another device. Contact support.',
      );
    }

    _activeEmail = normalizedEmail;
    return account.user;
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String currentDeviceSerial,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (!normalizedEmail.contains('@')) {
      throw const ServerException('Email format is invalid.');
    }
    if (password.length < 6) {
      throw const ServerException('Password must be at least 6 characters long.');
    }
    if (_accountsByEmail.containsKey(normalizedEmail)) {
      throw const ServerException('An account with this email already exists.');
    }

    final uid = DateTime.now().microsecondsSinceEpoch.toString();
    final account = _LocalAccount(
      user: UserModel(
        uid: uid,
        email: normalizedEmail,
        role: 'user',
        deviceSerial: currentDeviceSerial,
        isEmailVerified: false,
      ),
      password: password,
      deviceSerial: currentDeviceSerial,
    );

    _accountsByEmail[normalizedEmail] = account;
    _activeEmail = normalizedEmail;
    return account.user;
  }

  @override
  Future<void> logout() async {
    _activeEmail = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    final account = _currentAccount;
    if (account == null) {
      throw const ServerException('No authenticated user found.');
    }

    if (account.user.isEmailVerified) {
      return;
    }
    // TODO: Replace mock verification with real email service when backend is introduced.
    account.user = UserModel(
      uid: account.user.uid,
      email: account.user.email,
      role: account.user.role,
      deviceSerial: account.user.deviceSerial,
      isEmailVerified: true,
    );
  }

  @override
  Future<bool> checkEmailVerified() async {
    final account = _currentAccount;
    if (account == null) {
      throw const ServerException('No authenticated user found.');
    }
    return account.user.isEmailVerified;
  }

  @override
  Future<String> refreshAuthToken() async {
    final account = _currentAccount;
    if (account == null) {
      throw const ServerException('No authenticated user found.');
    }
    return 'local-token-${account.user.uid}-${DateTime.now().millisecondsSinceEpoch}';
  }

  _LocalAccount? get _currentAccount {
    final email = _activeEmail;
    if (email == null) {
      return null;
    }
    return _accountsByEmail[email];
  }
}

class _LocalAccount {
  _LocalAccount({
    required this.user,
    required this.password,
    required this.deviceSerial,
  });

  UserModel user;
  final String password;
  String deviceSerial;
}
