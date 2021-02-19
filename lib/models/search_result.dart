import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class SearchResult {
  final bool cancelled;
  final bool manual;
  final LatLng location;
  final String name;
  final String description;

  SearchResult({
    @required this.cancelled,
    this.manual,
    this.location,
    this.name,
    this.description,
  });
}
