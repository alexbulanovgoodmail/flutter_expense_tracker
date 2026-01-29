import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_expense_tracker/screens/expenses.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.deepPurpleAccent,
  brightness: Brightness.light,
);

Future<void> main() async {
  await initializeDateFormatting('en_US', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.onPrimary,
        ),
        cardTheme: CardThemeData().copyWith(
          color: kColorScheme.primaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
            foregroundColor: kColorScheme.onPrimaryContainer,
          ),
        ),
        textTheme: TextTheme().copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.w600,
            color: kColorScheme.onSecondaryContainer,
            fontSize: 24,
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.w600,
            color: kColorScheme.onSecondaryContainer,
            fontSize: 16,
          ),
          titleSmall: TextStyle(
            fontWeight: FontWeight.w600,
            color: kColorScheme.onSecondaryContainer,
            fontSize: 12,
          ),
          bodyMedium: TextStyle(color: kColorScheme.onPrimaryContainer),
        ),
      ),
      home: const ExpensesScreen(),
    );
  }
}
