import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  final String userEmail;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const SettingsPage({
    super.key,
    required this.userEmail,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // Profile section
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(userEmail),
            subtitle: const Text('Logged in user'),
          ),

          const Divider(),

          // Theme toggle
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDarkMode,
            onChanged: (_) => onToggleTheme(),
          ),

          const Divider(),

          //  Logout
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              context.read<AuthBloc>().add(AuthSignOutRequested());
            },
          ),
        ],
      ),
    );
  }
}
