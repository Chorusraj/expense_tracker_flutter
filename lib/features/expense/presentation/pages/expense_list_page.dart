import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import 'expense_form_page.dart';

class ExpenseListPage extends StatelessWidget {
  const ExpenseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Expenses')),
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
                      Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No expenses yet'),
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(expense.category),

                          if (expense.note != null && expense.note!.isNotEmpty)
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
                      trailing: Text('₹ ${expense.amount.toStringAsFixed(2)}'),
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
                  );
                },
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
