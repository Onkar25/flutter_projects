import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';

import '../models/place.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});

  final Place place;
  String get locationImage {
    final lat = place.location.latitude;
    final long = place.location.longitude;
    const apiKey = 'AIzaSyCGw1h9M7lfFhT8bpUEsZTQt1pWsWUDSPc';
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:O%7C$lat,$long&key=$apiKey';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            place.title,
          ),
        ),
        body: Stack(
          children: [
            Image.file(
              place.image,
              fit: BoxFit.fill,
              height: double.infinity,
              width: double.infinity,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => MapScreen(
                                placeLocation: place.location,
                                isSelectingLocation: false,
                              )));
                    },
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(locationImage),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      place.location.address,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
