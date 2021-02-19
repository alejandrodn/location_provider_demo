import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/helpers/calculating_alert.dart';
import 'package:maps_app/providers/location_service.dart';
import 'package:maps_app/providers/map_service.dart';
import 'package:maps_app/providers/search_service.dart';
import 'package:maps_app/providers/traffic_service.dart';
import 'package:provider/provider.dart';
import 'package:polyline/polyline.dart' as Poly;

class ManualMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchService>(builder: (context, search, child) {
      return search.manualSelection ? _BuildManualMarker() : Container();
    });
  }
}

class _BuildManualMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final searchService = Provider.of<SearchService>(context, listen: false);
    final locationService =
        Provider.of<LocationService>(context, listen: false);
    final mapService = Provider.of<MapService>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          child: FadeInLeft(
            child: CircleAvatar(
              maxRadius: 25,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  searchService.changeManualSelection(false);
                },
              ),
            ),
          ),
          top: 70,
          left: 20,
        ),
        Center(
          child: Transform.translate(
            offset: Offset(0, -20),
            child: BounceInDown(
              child: Icon(
                Icons.location_on,
                size: 50,
              ),
            ),
          ),
        ),
        Positioned(
          child: FadeIn(
            duration: Duration(milliseconds: 1500),
            child: MaterialButton(
                minWidth: size.width * 0.5,
                splashColor: Colors.transparent,
                shape: StadiumBorder(),
                elevation: 0,
                color: Colors.black,
                child: Text(
                  "Confirmar destino",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  this.calculateDestination(
                      context, locationService, mapService);
                }),
          ),
          bottom: 70,
          left: size.width * 0.25,
        ),
      ],
    );
  }

  void calculateDestination(BuildContext context,
      LocationService locationService, MapService mapService) async {
    calculatingAlert(context);
    final trafficService = TrafficService();
    final origin = locationService.lastKnownLocation;
    final destination = mapService.centerLocation;
    // Get location info
    final trafficResponse = await trafficService
        .getCoordinatesOriginDestination(origin, destination);
    final reverseGeocodingResponse =
        await trafficService.getLocationInfo(origin);
    print(reverseGeocodingResponse);
    final geometry = trafficResponse.routes[0].geometry;
    final duration = trafficResponse.routes[0].duration;
    final distance = trafficResponse.routes[0].distance;
    final destinationName = reverseGeocodingResponse.features[0].text;
    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6)
        .decodedCoords;
    final List<LatLng> coordinates =
        points.map((point) => LatLng(point[0], point[1])).toList();
    mapService.createOriginDestinationRoute(
        coordinates, distance, duration, destinationName);
    Provider.of<SearchService>(context).changeManualSelection(false);
    Navigator.pop(context);
  }
}
