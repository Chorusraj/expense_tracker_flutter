import 'package:expense_tracker/features/expense/data/datasources/expense_local_data_source.dart';
import 'package:expense_tracker/features/expense/data/datasources/expense_remote_data_source.dart';
import 'package:expense_tracker/features/expense/data/models/expense_model.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl(this.localDataSource,this.remoteDataSource,);

  @override
  Future<void> addExpense(ExpenseEntity expense) async{
     final model = ExpenseModel(
        id: expense.id,
        title: expense.title,
        amount: expense.amount,
        category: expense.category,
        date: expense.date,
        note: expense.note,
      );
    await localDataSource.addExpense(model);
    await remoteDataSource.addExpense(model);
  }

  @override
  Future<List<ExpenseEntity>> getExpenses() async {
    final localExpenses = await localDataSource.getExpenses();
    
    try{
      final remoteExpenses = await remoteDataSource.getExpenses();
      for(final expense in remoteExpenses){
        await localDataSource.addExpense(expense);
      }
    }catch(_){
      // offline - ignore
    }
    return localExpenses;
  }

  @override
  Future<void> updateExpense(ExpenseEntity expense) async {
    final model =  ExpenseModel(
        id: expense.id,
        title: expense.title,
        amount: expense.amount,
        category: expense.category,
        date: expense.date,
        note: expense.note,
      );
      await localDataSource.updateExpense(model);
      await remoteDataSource.updateExpense(model);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await localDataSource.deleteExpense(id);
    await remoteDataSource.deleteExpense(id);
  }
}
