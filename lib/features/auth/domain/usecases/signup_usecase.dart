import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:production_authentication_app/core/error/failures.dart';
import 'package:production_authentication_app/core/usecase/usecase.dart';
import 'package:production_authentication_app/features/auth/domain/entities/app_user.dart';
import 'package:production_authentication_app/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase implements UseCase<AppUser, SignUpParams> {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(SignUpParams params) {
    return repository.signUp(email: params.email, password: params.password);
  }
}

class SignUpParams extends Equatable {
  final String email;
  final String password;

  const SignUpParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
