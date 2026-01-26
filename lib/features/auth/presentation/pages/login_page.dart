import 'package:expense_tracker/core/widgets/custom_text_field.dart';
import 'package:expense_tracker/core/widgets/primary_button.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_tracker/features/auth/presentation/pages/register_page.dart';
import 'package:expense_tracker/features/expense/presentation/pages/expense_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  LoginPage({super.key, required this.onToggleTheme, required this.isDarkMode});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
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
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
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

                      // Password
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

                      const SizedBox(height: 24),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: CustomButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              return context.read<AuthBloc>().add(
                                AuthSignInRequested(
                                  _emailController.text,
                                  _passwordController.text,
                                ),
                              );
                            }
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
                            context.read<AuthBloc>().add(
                              AuthGoogleSignInRequested(),
                            );
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
                                MaterialPageRoute(
                                  builder: (_) => RegisterPage(
                                    onToggleTheme: widget.onToggleTheme,
                                    isDarkMode: widget.isDarkMode,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Sign Up'),
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
        );
      },
    );
  }
}
