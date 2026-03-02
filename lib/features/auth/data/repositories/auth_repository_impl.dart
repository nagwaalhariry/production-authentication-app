import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:production_authentication_app/core/error/exceptions.dart';
import 'package:production_authentication_app/core/error/failures.dart';
import 'package:production_authentication_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:production_authentication_app/features/auth/data/datasources/device_info_data_source.dart';
import 'package:production_authentication_app/features/auth/domain/entities/app_user.dart';
import 'package:production_authentication_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final DeviceInfoDataSource deviceInfoDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.deviceInfoDataSource,
  });

  @override
  Future<Either<Failure, AppUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      final deviceSerial = await deviceInfoDataSource.getDeviceSerial();
      final user = await remoteDataSource.login(
        email: email.trim(),
        password: password,
        currentDeviceSerial: deviceSerial,
      );
      return Right(user);
    } on SocketException {
      return const Left(NetworkFailure('No internet connection.'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on DeviceBindingException catch (e) {
      return Left(DeviceBindingFailure(e.message));
    } on UnauthorizedRoleException catch (e) {
      return Left(UnauthorizedRoleFailure(e.message));
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Unexpected login error occurred.'));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final deviceSerial = await deviceInfoDataSource.getDeviceSerial();
      final user = await remoteDataSource.signUp(
        email: email.trim(),
        password: password,
        currentDeviceSerial: deviceSerial,
      );
      return Right(user);
    } on SocketException {
      return const Left(NetworkFailure('No internet connection.'));
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Unexpected sign up error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Unexpected logout error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    try {
      await remoteDataSource.sendEmailVerification();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Unexpected verification email error.'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkEmailVerified() async {
    try {
      final isVerified = await remoteDataSource.checkEmailVerified();
      return Right(isVerified);
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Failed to check email verification.'));
    }
  }

  @override
  Future<Either<Failure, String>> refreshAuthToken() async {
    try {
      final token = await remoteDataSource.refreshAuthToken();
      if (token.isEmpty) {
        return const Left(AuthFailure('Unable to refresh authentication token.'));
      }
      return Right(token);
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Unexpected token refresh error.'));
    }
  }
}
