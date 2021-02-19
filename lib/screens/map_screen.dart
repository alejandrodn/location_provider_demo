import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/helpers/navigate_fade_in.dart';
import 'package:maps_app/providers/location_service.dart';
import 'package:maps_app/providers/map_service.dart';
import 'package:maps_app/screens/loading_screen.dart';
import 'package:maps_app/widgets/follow_button.dart';
import 'package:maps_app/widgets/location_button.dart';
import 'package:maps_app/widgets/manual_marker.dart';
import 'package:maps_app/widgets/route_button.dart';
import 'package:maps_app/widgets/search_bar.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static final routeName = 'map-screen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Provider.of<LocationService>(context, listen: false).initFollowing();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    Provider.of<LocationService>(context, listen: false).stopFollowing();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (!await Geolocator.isLocationServiceEnabled()) {
        Navigator.pushReplacement(
            context, navigateMapFadeIn(context, LoadingScreen()));
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final mapService = Provider.of<MapService>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Consumer2<LocationService, MapService>(
            builder: (context, location, map, child) {
              if (location.lastLocationExists) {
                final initialCameraPosition = CameraPosition(
                    target: location.lastKnownLocation, zoom: 15);
                mapService.newLocation(location.lastKnownLocation);
                return GoogleMap(
                  polylines: mapService.polylines.values.toSet(),
                  markers: mapService.markers.values.toSet(),
                  initialCameraPosition: initialCameraPosition,
                  compassEnabled: true,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: (mapController) {
                    mapService.initMap(mapController);
                  },
                  onCameraMove: (position) {
                    mapService.centerCamera(position);
                  },
                  onCameraIdle: () {
                    print('idle map');
                  },
                );
              } else {
                return Center(
                  child: Text('Ubicando'),
                );
              }
            },
          ),
          SearchBar(),
          ManualMarker(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          LocationButton(),
          RouteButton(),
          FollowButton(),
        ],
      ),
    );
  }
}
