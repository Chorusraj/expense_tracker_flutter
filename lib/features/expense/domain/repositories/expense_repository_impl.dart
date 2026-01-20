import 'package:expense_tracker/features/expense/data/datasources/expense_local_data_source.dart';
import 'package:expense_tracker/features/expense/data/models/expense_model.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  ExpenseRepositoryImpl(this.localDataSource);

  @override
  Future<void> addExpense(ExpenseEntity expense) {
    return localDataSource.addExpense(
      ExpenseModel(
        id: expense.id,
        title: expense.title,
        amount: expense.amount,
        category: expense.category,
        date: expense.date,
      ),
    );
  }

  @override
  Future<List<ExpenseEntity>> getExpenses() async {
    return await localDataSource.getExpenses();
  }

  @override
  Future<void> updateExpense(ExpenseEntity expense) {
    return localDataSource.updateExpense(
      ExpenseModel(
        id: expense.id,
        title: expense.title,
        amount: expense.amount,
        category: expense.category,
        date: expense.date,
      ),
    );
  }

  @override
  Future<void> deleteExpense(String id) {
    return localDataSource.deleteExpense(id);
  }
}
