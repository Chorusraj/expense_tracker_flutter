import 'package:expense_tracker/features/expense/domain/entities/expense_entity.dart';

abstract class ExpenseEvent {}

class LoadExpenses extends ExpenseEvent {}

class AddExpenseEvent extends ExpenseEvent {
  final ExpenseEntity expense;
  AddExpenseEvent(this.expense);
}

class UpdateExpenseEvent extends ExpenseEvent {
  final ExpenseEntity expense;
  UpdateExpenseEvent(this.expense);
}

class DeleteExpenseEvent extends ExpenseEvent {
  final String id;
  DeleteExpenseEvent(this.id);
}
