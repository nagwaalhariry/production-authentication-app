part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final RequestStatus status;
  final AppUser? user;
  final String errorMessage;
  final bool isAuthenticated;
  final bool isEmailVerified;

  const AuthState({
    this.status = RequestStatus.initial,
    this.user,
    this.errorMessage = '',
    this.isAuthenticated = false,
    this.isEmailVerified = false,
  });

  AuthState copyWith({
    RequestStatus? status,
    AppUser? user,
    String? errorMessage,
    bool? isAuthenticated,
    bool? isEmailVerified,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: errorMessage ?? this.errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        errorMessage,
        isAuthenticated,
        isEmailVerified,
      ];
}
