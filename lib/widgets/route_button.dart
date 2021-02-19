import 'package:flutter/material.dart';
import 'package:maps_app/providers/map_service.dart';
import 'package:provider/provider.dart';

class RouteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapService = Provider.of<MapService>(context);
    return Container(
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
            icon: Icon(
              mapService.drawPath ? Icons.more_horiz : Icons.more_vert,
              color: Colors.black,
            ),
            onPressed: () {
              mapService.togglePolyline();
              print("pressed");
            }),
      ),
      margin: const EdgeInsets.only(bottom: 10),
    );
  }
}
