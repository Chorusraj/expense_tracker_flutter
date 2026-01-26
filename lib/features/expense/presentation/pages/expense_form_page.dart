import 'package:expense_tracker/core/widgets/custom_text_field.dart';
import 'package:expense_tracker/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/expense_entity.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';

class ExpenseFormPage extends StatefulWidget {
  final ExpenseEntity? expense;
  const ExpenseFormPage({super.key, this.expense});

  bool get isEdit => expense != null;

  @override
  State<ExpenseFormPage> createState() => _ExpenseFormPage();
}

class _ExpenseFormPage extends State<ExpenseFormPage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String _category = 'Food';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.isEdit) {
      _titleController.text = widget.expense!.title;
      _amountController.text = widget.expense!.amount.toString();
      _category = widget.expense!.category;
      _noteController.text = widget.expense?.note ?? '';
    }
  }

  @override
  void dispose(){
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new)),
        title: Text(widget.isEdit ? 'Edit Expenses' : 'Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextformfield(
                  controller: _titleController,
                  labelText: 'Title',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
            
                CustomTextformfield(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  labelText: 'Amount',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Amount is required';
                    }
            
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Enter a valid amount';
                    }
            
                    return null;
                  },
                ),
                const SizedBox(height: 16),
            
                DropdownButtonFormField<String>(
                  value: _category,
                  items: const [
                    DropdownMenuItem(value: 'Food', child: Text('Food')),
                    DropdownMenuItem(value: 'Travel', child: Text('Travel')),
                    DropdownMenuItem(value: 'Rent', child: Text('Rent')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _category = value!;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
            
                const SizedBox(height: 16),
            
                CustomTextformfield(
                  controller: _noteController,
                  maxLines: 3,
                  labelText: 'Note (optional)',
                ),
            
                SizedBox(height: 24),
            
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      final expense = ExpenseEntity(
                        id: widget.isEdit
                            ? widget.expense!.id
                            : const Uuid().v4(),
                        title: _titleController.text,
                        amount: double.parse(_amountController.text),
                        category: _category,
                        date: widget.isEdit
                            ? widget.expense!.date
                            : DateTime.now(),
                        note: _noteController.text.isEmpty
                            ? null
                            : _noteController.text,
                      );
            
                      final bloc = context.read<ExpenseBloc>();
            
                      if (widget.isEdit) {
                        bloc.add(UpdateExpenseEvent(expense));
                      } else {
                        bloc.add(AddExpenseEvent(expense));
                      }
            
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
