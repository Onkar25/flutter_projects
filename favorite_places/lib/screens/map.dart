import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {super.key,
      this.placeLocation = const PlaceLocation(
        latitude: 37.232,
        longitude: -122.084,
        address: '',
      ),
      this.isSelectingLocation = true});
  final PlaceLocation placeLocation;
  final bool isSelectingLocation;

  State<MapScreen> createState() {
    return MapScreenState();
  }
}

class MapScreenState extends State<MapScreen> {
  LatLng? _selectedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelectingLocation
            ? 'Pick your location'
            : 'Selected location'),
        actions: [
          if (widget.isSelectingLocation)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pop(_selectedLocation);
              },
            ),
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelectingLocation
            ? null
            : (position) {
                setState(() {
                  _selectedLocation = position;
                });
              },
        initialCameraPosition: CameraPosition(
            target: LatLng(
              widget.placeLocation.latitude,
              widget.placeLocation.longitude,
            ),
            zoom: 16),
        markers: (_selectedLocation == null && widget.isSelectingLocation)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('value'),
                  position: _selectedLocation ??
                      LatLng(
                        widget.placeLocation.latitude,
                        widget.placeLocation.longitude,
                      ),
                ),
              },
      ),
    );
  }
}
