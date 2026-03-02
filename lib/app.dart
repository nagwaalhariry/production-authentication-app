import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:production_authentication_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:production_authentication_app/features/auth/data/datasources/device_info_data_source.dart';
import 'package:production_authentication_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:production_authentication_app/features/auth/domain/usecases/check_email_verified_usecase.dart';
import 'package:production_authentication_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:production_authentication_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:production_authentication_app/features/auth/domain/usecases/send_email_verification_usecase.dart';
import 'package:production_authentication_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:production_authentication_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:production_authentication_app/features/auth/presentation/pages/auth_gate_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final authRemoteDataSource = AuthRemoteDataSourceImpl();
    final deviceInfoDataSource = DeviceInfoDataSourceImpl();
    final authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
      deviceInfoDataSource: deviceInfoDataSource,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            loginUseCase: LoginUseCase(authRepository),
            signUpUseCase: SignUpUseCase(authRepository),
            logoutUseCase: LogoutUseCase(authRepository),
            sendEmailVerificationUseCase:
                SendEmailVerificationUseCase(authRepository),
            checkEmailVerifiedUseCase:
                CheckEmailVerifiedUseCase(authRepository),
          )..add(const AuthAppStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'Production Auth',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthGatePage(),
      ),
    );
  }
}
