import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:production_authentication_app/core/state/request_status.dart';
import 'package:production_authentication_app/core/usecase/usecase.dart';
import 'package:production_authentication_app/features/auth/domain/entities/app_user.dart';
import 'package:production_authentication_app/features/auth/domain/usecases/check_email_verified_usecase.dart';
import 'package:production_authentication_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:production_authentication_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:production_authentication_app/features/auth/domain/usecases/send_email_verification_usecase.dart';
import 'package:production_authentication_app/features/auth/domain/usecases/signup_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final LogoutUseCase logoutUseCase;
  final SendEmailVerificationUseCase sendEmailVerificationUseCase;
  final CheckEmailVerifiedUseCase checkEmailVerifiedUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.logoutUseCase,
    required this.sendEmailVerificationUseCase,
    required this.checkEmailVerifiedUseCase,
  }) : super(const AuthState()) {
    on<AuthAppStarted>(_onAppStarted);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthSendEmailVerificationRequested>(_onSendEmailVerificationRequested);
    on<AuthCheckEmailVerificationRequested>(_onCheckEmailVerificationRequested);
    on<AuthErrorConsumed>(_onErrorConsumed);
  }

  Future<void> _onAppStarted(
    AuthAppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: RequestStatus.initial, errorMessage: ''));
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: RequestStatus.loading, errorMessage: ''));

    final result = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RequestStatus.failure,
          errorMessage: failure.message,
          isAuthenticated: false,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: RequestStatus.success,
          user: user,
          isAuthenticated: true,
          isEmailVerified: user.isEmailVerified,
        ),
      ),
    );
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: RequestStatus.loading, errorMessage: ''));

    final result = await signUpUseCase(
      SignUpParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RequestStatus.failure,
          errorMessage: failure.message,
          isAuthenticated: false,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: RequestStatus.success,
          user: user,
          isAuthenticated: true,
          isEmailVerified: user.isEmailVerified,
        ),
      ),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: RequestStatus.loading, errorMessage: ''));

    final result = await logoutUseCase(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RequestStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: RequestStatus.success,
          isAuthenticated: false,
          isEmailVerified: false,
          clearUser: true,
        ),
      ),
    );
  }

  Future<void> _onSendEmailVerificationRequested(
    AuthSendEmailVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: RequestStatus.loading, errorMessage: ''));

    final result = await sendEmailVerificationUseCase(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RequestStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: RequestStatus.success)),
    );
  }

  Future<void> _onCheckEmailVerificationRequested(
    AuthCheckEmailVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: RequestStatus.loading, errorMessage: ''));

    final result = await checkEmailVerifiedUseCase(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RequestStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (isVerified) => emit(
        state.copyWith(
          status: RequestStatus.success,
          isEmailVerified: isVerified,
        ),
      ),
    );
  }

  void _onErrorConsumed(
    AuthErrorConsumed event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(errorMessage: ''));
  }
}
