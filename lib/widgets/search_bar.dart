import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/helpers/calculating_alert.dart';
import 'package:maps_app/models/search_result.dart';
import 'package:maps_app/providers/location_service.dart';
import 'package:maps_app/providers/map_service.dart';
import 'package:maps_app/providers/search_service.dart';
import 'package:maps_app/providers/traffic_service.dart';
import 'package:maps_app/search/search_destination.dart';
import 'package:polyline/polyline.dart' as Poly;
import 'package:provider/provider.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchService>(
      builder: (context, search, child) {
        return !search.manualSelection
            ? FadeInDown(child: _buildSearchBar(context))
            : Container();
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onTap: () async {
          Provider.of<SearchService>(context, listen: false)
              .changeManualSelection(false);
          final location = Provider.of<LocationService>(context, listen: false);
          final result = await showSearch(
              context: context,
              delegate: SearchDestination(location.lastKnownLocation));
          try {
            if (result == null) return;
            this.search(result, context);
          } catch (e) {
            print(e);
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          height: screenSize.height * 0.07,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              "¿A dónde quieres ir?",
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 5),
                )
              ]),
        ),
      ),
    );
  }

  Future<void> search(SearchResult result, BuildContext context) async {
    if (result.cancelled) return;

    if (result.manual) {
      Provider.of<SearchService>(context, listen: false)
          .changeManualSelection(true);
      return;
    }

    calculatingAlert(context);

    final trafficService = TrafficService();
    final locationService = Provider.of<LocationService>(context);
    final mapService = Provider.of<MapService>(context);
    final origin = locationService.lastKnownLocation;
    final destination = result.location;
    final drivingResponse = await trafficService
        .getCoordinatesOriginDestination(origin, destination);
    final geometry = drivingResponse.routes[0].geometry;
    final duration = drivingResponse.routes[0].duration;
    final distance = drivingResponse.routes[0].distance;

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6);
    final List<LatLng> coordinates = points.decodedCoords
        .map((point) => LatLng(point[0], point[1]))
        .toList();
    // mapService.createOriginDestinationRoute(coordinates, distance, duration);
    Navigator.pop(context);
  }
}
