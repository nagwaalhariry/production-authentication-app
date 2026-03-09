import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:production_authentication_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:production_authentication_app/features/auth/presentation/widgets/auth_card.dart';
import 'package:production_authentication_app/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:production_authentication_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:production_authentication_app/features/auth/presentation/widgets/section_header.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
    return AuthScaffold(
      appBarTitle: const Text('Create Account'),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Get started',
              subtitle: 'Create your account with your email and password.',
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
                      hint: 'Minimum 6 characters',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters';
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
                                AuthSignUpRequested(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                ),
                              );

                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.verified_user_rounded),
                        label: const Text('Create account'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
