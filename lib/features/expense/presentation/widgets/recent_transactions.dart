import 'package:flutter/material.dart';
import '../../domain/entities/expense_entity.dart';

class RecentTransactions extends StatelessWidget {
  final List<ExpenseEntity> expenses;

  const RecentTransactions({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const SizedBox.shrink();
    }

    final recent = expenses
        .toList()
        ..sort((a, b) => b.date.compareTo(a.date));

    final last5 = recent.take(5).toList();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...last5.map(
              (expense) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(expense.title),
                subtitle: Text(expense.category),
                trailing: Text('₹ ${expense.amount.toStringAsFixed(2)}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
