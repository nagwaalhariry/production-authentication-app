import 'package:dartz/dartz.dart';
import 'package:production_authentication_app/core/error/failures.dart';
import 'package:production_authentication_app/core/usecase/usecase.dart';
import 'package:production_authentication_app/features/auth/domain/repositories/auth_repository.dart';

class CheckEmailVerifiedUseCase implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  CheckEmailVerifiedUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.checkEmailVerified();
  }
}
