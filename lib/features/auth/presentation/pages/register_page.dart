import 'package:expense_tracker/core/widgets/custom_text_field.dart';
import 'package:expense_tracker/core/widgets/primary_button.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_tracker/features/expense/presentation/pages/expense_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  RegisterPage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ExpenseListPage(
                onToggleTheme: widget.onToggleTheme,
                isDarkMode: widget.isDarkMode,
              ),
            ),
          );
        }

        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.18),

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
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      borderRadius: 12,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    BlocBuilder<PasswordBloc, PasswordState>(
                      buildWhen: (prev, curr) =>
                          prev.isVisible != curr.isVisible,
                      builder: (context, state) {
                        return CustomTextformfield(
                          maxLines: 1,
                          obscureText: !state.isVisible,
                          controller: _passwordController,
                          labelText: 'Password',
                          borderRadius: 12,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a valid password';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            onPressed: () {
                              context.read<PasswordBloc>().add(
                                TooglePasswordVisibility(),
                              );
                            },
                            icon: Icon(
                              state.isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    BlocBuilder<PasswordBloc, PasswordState>(
                      buildWhen: (prev, curr) =>
                          prev.isVisible != curr.isVisible,
                      builder: (context, state) {
                        return CustomTextformfield(
                          maxLines: 1,
                          obscureText: !state.isVisible,
                          controller: _confirmPasswordController,
                          labelText: 'Confirm Password',
                          borderRadius: 12,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please confirm your password';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            onPressed: () {
                              context.read<PasswordBloc>().add(
                                TooglePasswordVisibility(),
                              );
                            },
                            icon: Icon(
                              state.isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: CustomButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
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
                          }
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

                    SizedBox(height: height * 0.15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
