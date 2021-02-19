import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/helpers/navigate_fade_in.dart';
import 'package:maps_app/screens/access_gps_screen.dart';
import 'package:maps_app/screens/map_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class LoadingScreen extends StatefulWidget {
  static const routeName = '/near-by';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (await Geolocator.isLocationServiceEnabled()) {
        Navigator.pushReplacement(
            context, navigateMapFadeIn(context, MapScreen()));
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(25.438764, -100.988815),
    zoom: 14.4746,
  );
  bool _createMap = false;
  BitmapDescriptor bitmapDescriptor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: this.checkGpsLocation(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Text(snapshot.data),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }
          // if (_createMap) {
          //   return Text('Map');
          // return GoogleMap(
          //   initialCameraPosition: _kGooglePlex,
          //   markers: {
          //     new Marker(
          //         markerId: MarkerId('saltillo'),
          //         position: LatLng(25.438764, -100.988815),
          //         icon: bitmapDescriptor)
          //   },
          // );
          // }
          // if (snapshot.connectionState == ConnectionState.done) {
          //   return Text('Map');
          // }
        },
      ),
    );
  }

  Future checkGpsLocation(BuildContext context) async {
    final gpsPermission = await Permission.location.isGranted;
    final isGpsEnabled = await Geolocator.isLocationServiceEnabled();
    if (gpsPermission && isGpsEnabled) {
      Navigator.pushReplacement(
          context, navigateMapFadeIn(context, MapScreen()));
      return '';
    } else if (!gpsPermission) {
      Navigator.pushReplacement(
          context, navigateMapFadeIn(context, AccessGpsScreen()));
      return 'Es necesario el permiso de GPS';
    } else {
      return 'Active el GPS';
    }
    // Navigator.pushReplacement(context, navigateMapFadeIn(context, MapScreen()));
    // Navigator.pushReplacement(
    //     context, navigateMapFadeIn(context, AccessGpsScreen()));
  }
}
