import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/models/expense.dart';

class ExpensesAdder extends StatefulWidget {
  const ExpensesAdder({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<ExpensesAdder> createState() => _ExpensesAdderState();
}

class _ExpensesAdderState extends State<ExpensesAdder> {
  void _submitExpense() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text);
    final selectedDate = _selectedDate;

    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (enteredTitle.isEmpty || amountIsInvalid || selectedDate == null) {
      _showErrorDialog();
      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: selectedDate,
        category: _selectedCategory,
      ),
    );

    Navigator.pop(context);
  }

  void _showErrorDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return CupertinoAlertDialog(
            title: const Text('Invalid Input'),
            content: const Text(
              'Please make sure a valid title, amount, and date were entered.',
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
            'Please make sure a valid title, amount, and date were entered.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  Category _selectedCategory = Category.others;
  void _handleDropdown(dynamic value) {
    setState(() {
      _selectedCategory = value;
    });
  }

  DateTime? _selectedDate;
  void _handleCalendar() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year + 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'Add New Expense',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Column(
                  children: <Widget>[
                    TextField(
                      controller: _titleController,
                      maxLength: 50,
                      decoration: const InputDecoration(label: Text('Title')),
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}'),
                              ), // разрешает только цифры
                            ],
                            decoration: const InputDecoration(
                              prefixText: '\$ ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: InkWell(
                              onTap: _handleCalendar,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  _selectedDate == null
                                      ? Text(
                                          'Select Date',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge,
                                        )
                                      : Text(
                                          dateFormatter.format(_selectedDate!),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge,
                                        ),
                                  const SizedBox(width: 8.0),
                                  const Icon(Icons.calendar_month),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24.0),

                    Row(
                      children: <Widget>[
                        DropdownButton<Category>(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem<Category>(
                                  value: category,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(categoryIcons[category]),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        category.name[0]
                                                .toUpperCase()
                                                .toString() +
                                            category.name.substring(1),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: _handleDropdown,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24.0),

                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextButton(
                            onPressed: _handleCancel,
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _submitExpense,
                            child: Text('Save Expense'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
