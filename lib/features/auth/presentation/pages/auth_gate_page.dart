import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:production_authentication_app/core/state/request_status.dart';
import 'package:production_authentication_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:production_authentication_app/features/auth/presentation/pages/home_page.dart';
import 'package:production_authentication_app/features/auth/presentation/pages/login_page.dart';

class AuthGatePage extends StatelessWidget {
  const AuthGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage.isNotEmpty,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(state.errorMessage),
            ),
          );
        context.read<AuthBloc>().add(const AuthErrorConsumed());
      },
      builder: (context, state) {
        if (state.status == RequestStatus.loading) {
          return const _LoadingState();
        }

        if (state.isAuthenticated && state.user != null) {
          return HomePage(user: state.user!);
        }

        return const LoginPage();
      },
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          child: Column(
            key: const ValueKey('loading-state'),
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 34,
                height: 34,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(height: 14),
              Text('Please wait...', style: textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
