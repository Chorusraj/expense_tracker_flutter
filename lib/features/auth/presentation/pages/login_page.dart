import 'package:expense_tracker/core/widgets/custom_text_field.dart';
import 'package:expense_tracker/core/widgets/primary_button.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_tracker/features/auth/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is AuthAuthenticated) {
          // Navigate to Home
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),

                  // Title
                  Text(
                    'Expense Tracker',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your expenses smartly',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 32),

                  // Email
                  CustomTextformfield(
                    labelText: 'Email',
                    controller: _emailController,
                    borderRadius: 12,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  CustomTextformfield(
                    obscureText: true,
                    controller: _passwordController,
                    labelText: 'Password',
                    borderRadius: 12,
                  ),

                  const SizedBox(height: 24),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: CustomButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          AuthSignInRequested(
                            _emailController.text,
                            _passwordController.text,
                          ),
                        );
                      },
                      child: const Text('Login'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Google Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthGoogleSignInRequested());
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Continue with Google'),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Signup
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RegisterPage()),
                          );
                        },
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
