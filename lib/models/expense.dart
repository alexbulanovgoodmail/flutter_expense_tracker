import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

const Uuid uuid = Uuid();

enum Category { food, travel, entertainment, utilities, leisure, work, others }

const categoryIcons = {
  Category.food: Icons.restaurant,
  Category.travel: Icons.flight,
  Category.entertainment: Icons.movie,
  Category.utilities: Icons.lightbulb,
  Category.leisure: Icons.beach_access,
  Category.work: Icons.work,
  Category.others: Icons.shopping_bag,
};

final dateFormatter = DateFormat('dd.MM.yyyy', 'en_US');
final currencyFormatter = NumberFormat.currency(
  locale: 'en_US',
  symbol: '\$',
  decimalDigits: 2,
);

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate => dateFormatter.format(date);
  String get formattedCurrency => currencyFormatter.format(amount);
}

class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
    : expenses = allExpenses
          .where((expense) => expense.category == category)
          .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
