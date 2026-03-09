import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:production_authentication_app/core/design/app_colors.dart';
import 'package:production_authentication_app/features/auth/domain/entities/app_user.dart';
import 'package:production_authentication_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:production_authentication_app/features/auth/presentation/widgets/auth_card.dart';
import 'package:production_authentication_app/features/auth/presentation/widgets/auth_scaffold.dart';

class HomePage extends StatelessWidget {
  final AppUser user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AuthScaffold(
      appBarTitle: const Text('Dashboard'),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Welcome, ${user.email.split('@').first}',
                    style: textTheme.headlineMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthLogoutRequested());
                  },
                  icon: const Icon(Icons.logout_rounded),
                  tooltip: 'Logout',
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Manage your account security and verification state.',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 18),
            AuthCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Account Details', style: textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _InfoRow(label: 'Email', value: user.email),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Role', value: user.role.toUpperCase()),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Device', value: user.deviceSerial),
                ],
              ),
            ),
            const SizedBox(height: 14),
            if (!user.isEmailVerified) ...[
              AuthCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: AppColors.warning),
                        const SizedBox(width: 8),
                        Text('Email Verification', style: textTheme.titleLarge),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your email is not verified yet. Verify it to unlock secure account actions.',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        FilledButton.tonalIcon(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  const AuthSendEmailVerificationRequested(),
                                );
                          },
                          icon: const Icon(Icons.email_outlined),
                          label: const Text('Send verification email'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  const AuthCheckEmailVerificationRequested(),
                                );
                          },
                          icon: const Icon(Icons.check_circle_outline_rounded),
                          label: const Text('I have verified'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
            _RoleCard(isAdmin: user.isAdmin),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(label, style: textTheme.bodySmall),
        ),
        Expanded(
          child: Text(value, style: textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final bool isAdmin;

  const _RoleCard({required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AuthCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isAdmin ? Icons.admin_panel_settings_rounded : Icons.person_rounded,
            color: isAdmin ? AppColors.primary : AppColors.secondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isAdmin
                  ? 'Admin access granted: privileged actions are available.'
                  : 'User access granted: standard actions are available.',
              style: textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
