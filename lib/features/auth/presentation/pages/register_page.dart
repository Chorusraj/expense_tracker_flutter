import 'package:expense_tracker/core/widgets/custom_text_field.dart';
import 'package:expense_tracker/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';


class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              Text(
                'Create Account',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Start tracking your expenses',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 32),

              CustomTextformfield(
                labelText: 'Email',
                controller: _emailController,
                borderRadius: 12,
              ),
              const SizedBox(height: 16),

              CustomTextformfield(
                labelText: 'Password',
                controller: _passwordController,
                obscureText: true,
                borderRadius: 12,
              ),
              const SizedBox(height: 16),

              CustomTextformfield(
                labelText: 'Confirm Password',
                controller: _confirmPasswordController,
                obscureText: true,
                borderRadius: 12,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: CustomButton(
                  onPressed: () {
                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Passwords do not match'),
                        ),
                      );
                      return;
                    }

                    context.read<AuthBloc>().add(
                          AuthSignUpRequested(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          ),
                        );
                  },
                  child: const Text('Register'),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
