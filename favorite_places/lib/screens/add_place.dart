import 'package:flutter/material.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleControler = TextEditingController();

  @override
  void dispose() {
    _titleControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: _titleControler,
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
              iconAlignment: IconAlignment.start,
              onPressed: () {},
              label: const Text('Add Place'),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
