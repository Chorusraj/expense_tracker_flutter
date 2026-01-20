import 'package:expense_tracker/features/expense/data/datasources/expense_local_data_source.dart';
import 'package:expense_tracker/features/expense/data/models/expense_model.dart';
import 'package:hive/hive.dart';

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  static const String boxName = 'expenses';

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    final box = await Hive.openBox<ExpenseModel>(boxName);
    await box.put(expense.id, expense);
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    final box = await Hive.openBox<ExpenseModel>(boxName);
    return box.values.toList();
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    final box = await Hive.openBox<ExpenseModel>(boxName);
    await box.put(expense.id, expense);
  }

  @override
  Future<void> deleteExpense(String id) async {
    final box = await Hive.openBox<ExpenseModel>(boxName);
    await box.delete(id);
  }
}