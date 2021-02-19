import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/helpers/custom_marker.dart';
import 'package:maps_app/themes/uber_map_theme.dart';

class MapService with ChangeNotifier {
  bool mapReady = false;
  bool drawPath = true;
  bool followLocation = false;
  LatLng centerLocation;

  GoogleMapController _mapController;

  Polyline _myRoute = Polyline(
    polylineId: PolylineId('myRoute'),
    color: Colors.black,
    width: 4,
  );

  Polyline _destinationRoute = Polyline(
    polylineId: PolylineId('myDestinationRoute'),
    color: Colors.black,
    width: 4,
  );

  Map<String, Polyline> polylines = {};
  Map<String, Marker> markers = {};

  // Map<String, Polyline> get polylines {
  //   return _myRoutes;
  // }

  void initMap(GoogleMapController googleMapController) {
    if (!mapReady) {
      this._mapController = googleMapController;
      this._mapController.setMapStyle(jsonEncode(uberMapTheme));
      // cambiar el estilo del mapa
      this.mapReady = true;
      notifyListeners();
    }
  }

  void moveCamera(LatLng destination) {
    final cameraUpdate = CameraUpdate.newLatLng(destination);
    this._mapController?.animateCamera(cameraUpdate);
  }

  void newLocation(LatLng location) {
    if (followLocation) {
      moveCamera(location);
    }
    List<LatLng> points = [...this._myRoute.points, location];
    this._myRoute = this._myRoute.copyWith(pointsParam: points);
    polylines['myRoute'] = this._myRoute;
  }

  void togglePolyline() {
    this._myRoute = this
        ._myRoute
        .copyWith(colorParam: drawPath ? Colors.black87 : Colors.transparent);

    polylines['myRoute'] = this._myRoute;
    this.drawPath = !this.drawPath;
    notifyListeners();
  }

  void toggleFollowLocation() {
    followLocation = !followLocation;
    notifyListeners();
  }

  void centerCamera(CameraPosition cameraPosition) {
    this.centerLocation = cameraPosition.target;
  }

  void createOriginDestinationRoute(List<LatLng> coordinates, double distance,
      double duration, String destinationName) async {
    this._destinationRoute =
        this._destinationRoute.copyWith(pointsParam: coordinates);

    final currentPolylines = polylines;
    currentPolylines['destinationRoute'] = this._destinationRoute;

    final icon = await getAssetImageMarker();

    final originMarker = Marker(
      markerId: MarkerId("origin"),
      position: coordinates.first,
      icon: icon,
      infoWindow: InfoWindow(
        title: "Mi ubicación",
        snippet: "Duración recorrido: ${(duration / 60).floor()} min",
      ),
    );

    double kms = distance / 1000;
    kms = (kms * 100).floorToDouble();
    kms = kms / 100;

    final icon2 = await getNetworkImageMarker();

    final destinationMarker = Marker(
      markerId: MarkerId("destination"),
      position: coordinates.last,
      icon: icon2,
      infoWindow: InfoWindow(
        title: destinationName,
        snippet: "Distancia: $kms Km",
      ),
    );

    final newMarkers = {...markers};
    newMarkers["origin"] = originMarker;
    newMarkers["destination"] = destinationMarker;

    this.markers = newMarkers;

    notifyListeners();
  }
}
