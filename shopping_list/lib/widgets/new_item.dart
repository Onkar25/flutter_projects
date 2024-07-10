import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:http/http.dart' as http;

import '../models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});
  @override
  State<NewItem> createState() {
    return NewItemState();
  }
}

class NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enterName = '';
  var _enterQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;
  var isSending = false;
  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      isSending = true;
      final url = Uri.https('flutter-pref-379e7-default-rtdb.firebaseio.com',
          'shopping-list.json');

      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': _enterName,
            'quantity': _enterQuantity,
            'category': _selectedCategory.title,
          }));
      isSending = false;

      if (!context.mounted) {
        return;
      }
      final Map<String, dynamic> data = json.decode(response.body);
      // Navigator.of(context).pop();
      Navigator.of(context).pop(GroceryItem(
          id: data['name'],
          name: _enterName,
          quantity: _enterQuantity,
          category: _selectedCategory));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text(
                    'Name',
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length == 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 to 50 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enterName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      initialValue: '1',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be valid , positive number.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enterQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 15,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  category.value.title,
                                ),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isSending
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                          },
                    child: const Text(
                      'Reset',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: isSending ? null : _saveItem,
                    child: isSending
                        ? const SizedBox(
                            height: 14,
                            width: 14,
                            child: CircularProgressIndicator(),
                          )
                        : const Text(
                            'Save Item',
                          ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
