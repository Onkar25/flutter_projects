import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;

import '../data/categories.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryList = [];
  String? _error;
  var isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctc) => const NewItem()));
    // _loadItems();
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryList.add(newItem);
      isLoading = false;
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryList.indexOf(item);
    setState(() {
      _groceryList.remove(item);
    });

    final url = Uri.https('flutter-pref-379e7-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');
    var response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        _groceryList.insert(index, item);
      });
    }
  }

  void _loadItems() async {
    final url = Uri.https(
        'flutter-pref-379e7-default-rtdb.firebaseio.com', 'shopping-list.json');
    final List<GroceryItem> loadedItem = [];
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data , please try again later .';
        });
      }

      if (response.body == 'null') {
        setState(() {
          isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> listData = json.decode(response.body);
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
                (catItem) => catItem.value.title == item.value['category'])
            .value;
        loadedItem.add(GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category));
      }
      setState(() {
        _groceryList = loadedItem;
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong !!! , please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No items in the list'),
    );

    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }
    if (_groceryList.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryList.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(_groceryList[index].id),
          onDismissed: (direction) {
            _removeItem(_groceryList[index]);
          },
          child: ListTile(
            title: Text(
              _groceryList[index].name,
            ),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryList[index].category.color,
            ),
            trailing: Text(
              _groceryList[index].quantity.toString(),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(
              Icons.add,
            ),
          )
        ],
      ),
      body: content,
    );
  }
}
