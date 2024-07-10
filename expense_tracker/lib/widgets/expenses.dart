import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expense_list/expense_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpenseState();
  }
}

class _ExpenseState extends State<Expenses> {
  final List<Expense> _regExpenses = [
    Expense(
        title: 'Flutter Crash Course',
        amount: 2000,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'New Clother',
        amount: 5000,
        date: DateTime.now(),
        category: Category.leisure),
    Expense(
        title: 'Chocolate',
        amount: 1000,
        date: DateTime.now(),
        category: Category.food)
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _regExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _regExpenses.indexOf(expense);
    setState(() {
      _regExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text(
          'Expense Deleted',
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(
              () {
                _regExpenses.insert(expenseIndex, expense);
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    // print('Width : $width and Height : $height');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: width < height
          ? Column(
              children: [
                Chart(expenses: _regExpenses),
                Expanded(
                  child: ExpenseList(
                      expenses: _regExpenses, onRemove: _removeExpense),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _regExpenses),
                ),
                Expanded(
                  child: ExpenseList(
                      expenses: _regExpenses, onRemove: _removeExpense),
                ),
              ],
            ),
    );
  }
}
