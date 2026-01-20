import 'package:hive/hive.dart';
import '../../domain/entities/expense_entity.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 1)
class ExpenseModel extends ExpenseEntity {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final DateTime date;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  }) : super(
          id: id,
          title: title,
          amount: amount,
          category: category,
          date: date,
        );
}
