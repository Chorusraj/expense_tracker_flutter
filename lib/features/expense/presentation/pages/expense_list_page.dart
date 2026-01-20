import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import 'add_expense_page.dart';

class ExpenseListPage extends StatelessWidget {
  const ExpenseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Expenses')),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
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
                    Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('No expenses yet'),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: state.expenses.length,
              itemBuilder: (context, index) {
                final expense = state.expenses[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(expense.title),
                    subtitle: Text(expense.category),
                    trailing: Text('₹ ${expense.amount.toStringAsFixed(2)}'),
                    onLongPress: () {
                      context.read<ExpenseBloc>().add(
                        DeleteExpenseEvent(expense.id),
                      );
                    },
                  ),
                );
              },
            );
          }

          if (state is ExpenseError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExpensePage()),
          );

          context.read<ExpenseBloc>().add(LoadExpenses());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
