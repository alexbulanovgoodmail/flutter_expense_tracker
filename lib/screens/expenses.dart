import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/models/expense.dart';
import 'package:flutter_expense_tracker/widgets/chart.dart';
import 'package:flutter_expense_tracker/widgets/expenses_adder.dart';
import 'package:flutter_expense_tracker/widgets/expenses_list.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Groceries',
      amount: 50.0,
      date: DateTime.now(),
      category: Category.food,
    ),
    Expense(
      title: 'Movie Tickets',
      amount: 30.0,
      date: DateTime.now(),
      category: Category.entertainment,
    ),
    Expense(
      title: 'Electricity Bill',
      amount: 75.0,
      date: DateTime.now(),
      category: Category.utilities,
    ),
  ];

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted.'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  void _openAddExpenseModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) {
        return ExpensesAdder(onAddExpense: _addExpense);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isWideScreen = width >= 600;

    Widget mainContent = const Center(
      child: Text(
        'No expenses found. Start adding some!',
        style: TextStyle(fontSize: 16.0),
      ),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: <Widget>[
          IconButton(
            onPressed: _openAddExpenseModal,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: isWideScreen
          ? Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(child: mainContent),
              ],
            )
          : Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
