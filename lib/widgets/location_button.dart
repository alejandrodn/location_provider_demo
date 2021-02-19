import 'package:flutter/material.dart';
import 'package:maps_app/providers/location_service.dart';
import 'package:maps_app/providers/map_service.dart';
import 'package:provider/provider.dart';

class LocationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locationService =
        Provider.of<LocationService>(context, listen: false);
    final mapService = Provider.of<MapService>(context, listen: false);
    return Container(
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
            icon: Icon(
              Icons.my_location,
              color: Colors.black,
            ),
            onPressed: () {
              final destination = locationService.lastKnownLocation;
              mapService.moveCamera(destination);
            }),
      ),
      margin: const EdgeInsets.only(bottom: 10),
    );
  }
}
