import 'package:flutter/material.dart';
import '../../domain/entities/expense_entity.dart';

class MonthlyTotalCard extends StatelessWidget {
  final List<ExpenseEntity> expenses;

  const MonthlyTotalCard({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final monthlyTotal = expenses
        .where((e) =>
            e.date.month == now.month &&
            e.date.year == now.year)
        .fold<double>(0, (sum, e) => sum + e.amount);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This Month',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              '₹ ${monthlyTotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
