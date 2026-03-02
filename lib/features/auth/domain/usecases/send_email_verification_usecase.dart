import 'package:dartz/dartz.dart';
import 'package:production_authentication_app/core/error/failures.dart';
import 'package:production_authentication_app/core/usecase/usecase.dart';
import 'package:production_authentication_app/features/auth/domain/repositories/auth_repository.dart';

class SendEmailVerificationUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  SendEmailVerificationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.sendEmailVerification();
  }
}
