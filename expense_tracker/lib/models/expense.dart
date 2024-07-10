import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

const uuid = Uuid();
final formatter = DateFormat('dd MMMM yyyy');

enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.leisure: Icons.money,
  Category.travel: Icons.travel_explore,
  Category.work: Icons.work
};

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

  String get formatedDate => formatter.format(date);
}

class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expense});
  final Category category;
  final List<Expense> expense;

  ExpenseBucket.forCategory(List<Expense> allExpense, this.category)
      : expense = allExpense
            .where((expense) => expense.category == category)
            .toList();
  double get totalExpenses {
    double sum = 0;

    for (final expense in expense) {
      sum += expense.amount;
    }
    return sum;
  }
}
