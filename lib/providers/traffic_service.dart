import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/models/driving_response.dart';
import 'package:maps_app/models/geocoding_response.dart';
import 'package:maps_app/models/reverse_geocoding_response.dart';

class TrafficService {
  TrafficService._privateConstructor();
  static final TrafficService _instance = TrafficService._privateConstructor();
  factory TrafficService() {
    return _instance;
  }
  final _dio = new Dio();
  final _baseUrl = "https://api.mapbox.com/directions/v5";
  final _geoUrl = "https://api.mapbox.com/geocoding/v5";

  final _apiKey =
      "pk.eyJ1IjoiYmVuamFtaW5kbHJuIiwiYSI6ImNrbDQyYXdyazBwODgydnA2Z3drOHdkMjMifQ.gkp_v3-fSAG8yLzxHE-96w";

  Future<DrivingResponse> getCoordinatesOriginDestination(
      LatLng origin, LatLng destination) async {
    final coordinatesString =
        "${origin.longitude}, ${origin.latitude};${destination.longitude},${destination.latitude}";
    final url = "$_baseUrl/mapbox/driving/$coordinatesString";

    final response = await this._dio.get(url, queryParameters: {
      "alternatives": "true",
      "geometries": "polyline6",
      "steps": "false",
      "access_token": this._apiKey,
      "language": "es",
    });

    final data = DrivingResponse.fromJson(response.data);

    return data;
  }

  Future<GeocodingResponse> getResultsByQuery(
      String search, LatLng proximity) async {
    final url = "${this._geoUrl}/mapbox.places/$search.json";
    final resp = await this._dio.get(url, queryParameters: {
      "access_token": this._apiKey,
      "autocomplete": "true",
      "proximity": "${proximity.longitude}, ${proximity.latitude}",
      "language": "es",
    });

    final data = geocodingResponseFromJson(resp.data);
    return data;
  }

  Future<ReverseGeocodingResponse> getLocationInfo(LatLng location) async {
    final locationString = "${location.longitude}, ${location.latitude}";
    final url = "${this._geoUrl}/mapbox.places/$locationString.json";
    final resp = await this._dio.get(url, queryParameters: {
      "access_token": this._apiKey,
      "language": "es",
    });
    final data = reverseGeocodingResponseFromJson(resp.data);
    return data;
  }
}
