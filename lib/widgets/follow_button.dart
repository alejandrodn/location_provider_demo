import 'package:flutter/material.dart';
import 'package:maps_app/providers/map_service.dart';
import 'package:provider/provider.dart';

class FollowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapService = Provider.of<MapService>(context);
    return Container(
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
            icon: Icon(
              mapService.followLocation
                  ? Icons.accessibility_new
                  : Icons.directions_run,
              color: Colors.black,
            ),
            onPressed: () {
              mapService.toggleFollowLocation();
            }),
      ),
      margin: const EdgeInsets.only(bottom: 10),
    );
  }
}
