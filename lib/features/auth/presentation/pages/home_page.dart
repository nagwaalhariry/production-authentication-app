import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:production_authentication_app/features/auth/domain/entities/app_user.dart';
import 'package:production_authentication_app/features/auth/presentation/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  final AppUser user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: ${user.email}'),
              const SizedBox(height: 8),
              Text('Role: ${user.role.toUpperCase()}'),
              const SizedBox(height: 8),
              Text('Device serial: ${user.deviceSerial}'),
              const SizedBox(height: 16),
              if (!user.isEmailVerified)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email not verified. Please verify before using restricted actions.',
                      style: TextStyle(color: Colors.orange),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton.tonal(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  const AuthSendEmailVerificationRequested(),
                                );
                          },
                          child: const Text('Send verification email'),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  const AuthCheckEmailVerificationRequested(),
                                );
                          },
                          child: const Text('I have verified'),
                        ),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              _RoleCard(isAdmin: user.isAdmin),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final bool isAdmin;

  const _RoleCard({required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          isAdmin
              ? 'Admin access granted: privileged actions are available.'
              : 'User access granted: standard actions are available.',
        ),
      ),
    );
  }
}
