import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:production_authentication_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:production_authentication_app/features/auth/presentation/pages/signup_page.dart';
import 'package:production_authentication_app/features/auth/presentation/widgets/auth_card.dart';
import 'package:production_authentication_app/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:production_authentication_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:production_authentication_app/features/auth/presentation/widgets/section_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AuthScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Welcome back',
              subtitle: 'Sign in to continue using your secure account.',
            ),
            const SizedBox(height: 18),
            AuthCard(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          if (_formKey.currentState?.validate() != true) {
                            return;
                          }

                          context.read<AuthBloc>().add(
                                AuthLoginRequested(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                ),
                              );
                        },
                        icon: const Icon(Icons.lock_open_rounded),
                        label: const Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SignUpPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: Text('Create account', style: textTheme.bodyMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
