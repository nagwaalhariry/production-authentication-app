import 'package:dartz/dartz.dart';
import 'package:production_authentication_app/core/error/failures.dart';
import 'package:production_authentication_app/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AppUser>> signUp({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> sendEmailVerification();

  Future<Either<Failure, bool>> checkEmailVerified();

  Future<Either<Failure, String>> refreshAuthToken();
}
