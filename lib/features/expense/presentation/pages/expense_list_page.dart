import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_tracker/features/expense/presentation/widgets/category_pie_chart.dart';
import 'package:expense_tracker/features/expense/presentation/widgets/monthly_total_card.dart';
import 'package:expense_tracker/features/expense/presentation/widgets/recent_transactions.dart';
import 'package:expense_tracker/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import 'expense_form_page.dart';

class ExpenseListPage extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const ExpenseListPage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsPage(
                    userEmail:
                        context.read<AuthBloc>().state is AuthAuthenticated
                        ? (context.read<AuthBloc>().state as AuthAuthenticated)
                              .user
                              .email
                        : '',
                    isDarkMode: isDarkMode,
                    onToggleTheme: onToggleTheme,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocListener<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state) {
            if (state is ExpenseLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ExpenseSyncing) {
              return const LinearProgressIndicator();
            }

            if (state is ExpenseLoaded) {
              if (state.expenses.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        'No expenses yet.\nAdd your first one!',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.only(bottom: 80),
                children: [
                  MonthlyTotalCard(expenses: state.expenses),
                  CategoryPieChart(expenses: state.expenses),
                  RecentTransactions(expenses: state.expenses),
                  SizedBox(height: 8),

                  ...state.expenses.map(
                    (expense) => Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(expense.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(expense.category),

                            if (expense.note != null &&
                                expense.note!.isNotEmpty)
                              Text(
                                expense.note!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                        trailing: Text(
                          '₹ ${expense.amount.toStringAsFixed(2)}',
                        ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ExpenseFormPage(expense: expense),
                            ),
                          );
                          context.read<ExpenseBloc>().add(LoadExpenses());
                        },
                        onLongPress: () {
                          context.read<ExpenseBloc>().add(
                            DeleteExpenseEvent(expense.id),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }

            if (state is ExpenseError) {
              return Center(child: Text(state.message));
            }

            return SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ExpenseFormPage()),
          );

          context.read<ExpenseBloc>().add(LoadExpenses());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
