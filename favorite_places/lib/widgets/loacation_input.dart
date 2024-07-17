import 'dart:convert';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LoacationInput extends StatefulWidget {
  const LoacationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;
  @override
  State<LoacationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LoacationInput> {
  PlaceLocation? _pickedCurrentLocation;
  final apiKey = 'AIzaSyCGw1h9M7lfFhT8bpUEsZTQt1pWsWUDSPc';
  String get locationImage {
    if (_pickedCurrentLocation == null) {
      return '';
    }
    final lat = _pickedCurrentLocation!.latitude;
    final long = _pickedCurrentLocation!.longitude;

    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:O%7C$lat,$long&key=$apiKey';
  }

  var isGettingLocation = false;
  void ShowLocation(double latitude, double longitude) async {
    final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey');

    final response = await http.get(uri);
    final resData = json.decode(response.body);
    final finalAddress = resData['results'][0]['formatted_address'];

    setState(() {
      _pickedCurrentLocation = PlaceLocation(
        latitude: latitude,
        longitude: longitude,
        address: finalAddress,
      );
      isGettingLocation = false;
    });

    widget.onSelectLocation(_pickedCurrentLocation!);
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      isGettingLocation = true;
    });
    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final long = locationData.longitude;

    if (lat == null || long == null) {
      return;
    }

    ShowLocation(lat, long);
  }

  Future<void> pickLocation() async {
    final getPickLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(),
      ),
    );

    if (getPickLocation == null) return;

    ShowLocation(getPickLocation.latitude, getPickLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No Location selected',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );

    if (_pickedCurrentLocation != null) {
      previewContent = Image.network(
        locationImage,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.fill,
      );
    }
    if (isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(
                Icons.location_on,
              ),
              onPressed: _getCurrentLocation,
              label: const Text('Get Current Location'),
            ),
            TextButton.icon(
              icon: const Icon(
                Icons.map,
              ),
              onPressed: pickLocation,
              label: const Text('Select on Map'),
            )
          ],
        )
      ],
    );
  }
}
