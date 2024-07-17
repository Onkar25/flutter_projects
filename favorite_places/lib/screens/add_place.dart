import 'dart:io';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/user_place.dart';
import 'package:favorite_places/widgets/loacation_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/image_input.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleControler = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;
  @override
  void dispose() {
    _titleControler.dispose();
    super.dispose();
  }

  void savePlace() {
    final enterTitle = _titleControler.text;
    if (enterTitle.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null) {
      return;
    }
    ref.read(userplaceProvide.notifier).addPlace(
          enterTitle,
          _selectedImage!,
          _selectedLocation!,
        );

    Navigator.of(context).pop();
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
            ImageInput(
              onImagePick: (image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            LoacationInput(
              onSelectLocation: (location) {
                _selectedLocation = location;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
              iconAlignment: IconAlignment.start,
              onPressed: savePlace,
              label: const Text('Add Place'),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
