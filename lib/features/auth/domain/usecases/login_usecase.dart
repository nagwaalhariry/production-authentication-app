import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:production_authentication_app/core/error/failures.dart';
import 'package:production_authentication_app/core/usecase/usecase.dart';
import 'package:production_authentication_app/features/auth/domain/entities/app_user.dart';
import 'package:production_authentication_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<AppUser, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(LoginParams params) {
    return repository.login(email: params.email, password: params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
