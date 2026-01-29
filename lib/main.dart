import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_expense_tracker/screens/expenses.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.deepPurpleAccent,
  brightness: Brightness.light,
);

var kColorDarkScheme = ColorScheme.fromSeed(
  seedColor: Colors.deepPurpleAccent,
  brightness: Brightness.dark,
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
          titleLarge: TextStyle(color: kColorScheme.onSecondaryContainer),
          titleMedium: TextStyle(color: kColorScheme.onSecondaryContainer),
          titleSmall: TextStyle(color: kColorScheme.onSecondaryContainer),
          bodyMedium: TextStyle(color: kColorScheme.onPrimaryContainer),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(colorScheme: kColorDarkScheme),
      themeMode: ThemeMode.system,
      home: const ExpensesScreen(),
    );
  }
}
