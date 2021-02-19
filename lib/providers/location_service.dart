import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService with ChangeNotifier {
  bool _following = false;
  bool _lastLocationExists = false;
  LatLng _lastKnownLocation;
  StreamSubscription<Position> _positionSubscription;

  bool get following {
    return this._following;
  }

  bool get lastLocationExists {
    return this._lastLocationExists;
  }

  LatLng get lastKnownLocation {
    return this._lastKnownLocation;
  }

  // LocationService({
  //   this.following = true,
  //   this.lastLocation = false,
  //   this.location,
  // });

  void initFollowing() {
    _positionSubscription = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ).listen((Position position) {
      final location = new LatLng(position.latitude, position.longitude);
      _lastLocationExists = true;
      _lastKnownLocation = location;
      notifyListeners();
    });
  }

  void stopFollowing() {
    _positionSubscription?.cancel();
  }
}
