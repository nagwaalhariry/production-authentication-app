import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:production_authentication_app/core/error/failures.dart';
import 'package:production_authentication_app/features/auth/domain/entities/app_user.dart';
import 'package:production_authentication_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:production_authentication_app/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginUseCase(repository);
  });

  const params = LoginParams(
    email: 'user@example.com',
    password: 'P@ssword123',
  );

  const user = AppUser(
    uid: 'uid-1',
    email: 'user@example.com',
    role: 'user',
    deviceSerial: 'device-abc',
    isEmailVerified: false,
  );

  test('returns user when repository login succeeds', () async {
    when(
      () => repository.login(email: params.email, password: params.password),
    ).thenAnswer((_) async => const Right(user));

    final result = await useCase(params);

    expect(result, const Right(user));
    verify(
      () => repository.login(email: params.email, password: params.password),
    ).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('returns failure when repository login fails', () async {
    when(
      () => repository.login(email: params.email, password: params.password),
    ).thenAnswer((_) async => const Left(AuthFailure('Invalid credentials')));

    final result = await useCase(params);

    expect(result, const Left(AuthFailure('Invalid credentials')));
    verify(
      () => repository.login(email: params.email, password: params.password),
    ).called(1);
    verifyNoMoreInteractions(repository);
  });
}
