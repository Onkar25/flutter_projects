import 'dart:io';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _textTitleController = TextEditingController();
  final _textAmountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectCategory = Category.food;

  @override
  void dispose() {
    _textTitleController.dispose();
    _textAmountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickDate = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: now);

    setState(() {
      _selectedDate = pickDate;
    });
  }

  void showMyDialog() {
    if (Platform.isMacOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid Input'),
          content:
              const Text('Please make sure you have entered proper values '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content:
              const Text('Please make sure you have entered proper values '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_textAmountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_textTitleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      // Show error
      showMyDialog();
      return;
    }
    widget.onAddExpense(Expense(
        title: _textTitleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectCategory));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, contraint) {
      final width = contraint.maxWidth;
      final height = contraint.maxHeight;

      print('Width : $width and Height : $height');
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, keyboardSpace + 15),
            child: Column(
              children: [
                if (width >= height)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textTitleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _textAmountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefix: Text('\u{20B9} '),
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _textTitleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),
                if (width >= height)
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton(
                          value: _selectCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectCategory = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No date Selected '
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(
                                    Icons.calendar_view_month_outlined))
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textAmountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefix: Text('\u{20B9} '),
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No date Selected '
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(
                                    Icons.calendar_view_month_outlined))
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (width >= height)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save Expense'),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropdownButton(
                        value: _selectCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectCategory = value;
                          });
                        },
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save Expense'),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
