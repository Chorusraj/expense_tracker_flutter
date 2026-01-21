import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/features/expense/data/datasources/expense_remote_data_source.dart';
import 'package:expense_tracker/features/expense/data/models/expense_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ExpenseRemoteDataSourceImpl(this.firestore, this.firebaseAuth);

  CollectionReference get _expenseRef {
    final uid = firebaseAuth.currentUser!.uid;
    return firestore.collection('users').doc(uid).collection('expenses');
  }

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await _expenseRef.doc(expense.id).set({
      'id': expense.id,
      'title': expense.title,
      'amount': expense.amount,
      'category': expense.category,
      'date': expense.date.toIso8601String(),
      'note':expense.note,
    });
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await _expenseRef.doc(expense.id).update({
      'title': expense.title,
      'amount': expense.amount,
      'category': expense.category,
      'date': expense.date.toIso8601String(),
      'note':expense.note,
    });
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _expenseRef.doc(id).delete();
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    final snapshot = await _expenseRef.get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return ExpenseModel(
        id: data['id'],
        title: data['title'],
        amount: data['amount'],
        category: data['category'],
        date: DateTime.parse(data['date']),
        note: data['note'],
      );
    }).toList();
  }
}
