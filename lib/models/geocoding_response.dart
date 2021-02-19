// To parse this JSON data, do
//
//     final geocodingResponse = geocodingResponseFromJson(jsonString);

import 'dart:convert';

GeocodingResponse geocodingResponseFromJson(String str) =>
    GeocodingResponse.fromJson(json.decode(str));

String geocodingResponseToJson(GeocodingResponse data) =>
    json.encode(data.toJson());

class GeocodingResponse {
  GeocodingResponse({
    this.type,
    this.query,
    this.features,
    this.attribution,
  });

  String type;
  List<String> query;
  List<Feature> features;
  String attribution;

  factory GeocodingResponse.fromJson(Map<String, dynamic> json) =>
      GeocodingResponse(
        type: json["type"],
        query: List<String>.from(json["query"].map((x) => x)),
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromJson(x))),
        attribution: json["attribution"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "query": List<dynamic>.from(query.map((x) => x)),
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
        "attribution": attribution,
      };
}

class Feature {
  Feature({
    this.id,
    this.type,
    this.placeType,
    this.relevance,
    this.properties,
    this.text,
    this.placeName,
    this.bbox,
    this.center,
    this.geometry,
    this.context,
  });

  String id;
  String type;
  List<String> placeType;
  int relevance;
  Properties properties;
  String text;
  String placeName;
  List<double> bbox;
  List<double> center;
  Geometry geometry;
  List<Context> context;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        type: json["type"],
        placeType: List<String>.from(json["place_type"].map((x) => x)),
        relevance: json["relevance"],
        properties: Properties.fromJson(json["properties"]),
        text: json["text"],
        placeName: json["place_name"],
        bbox: json["bbox"] == null
            ? null
            : List<double>.from(json["bbox"].map((x) => x.toDouble())),
        center: List<double>.from(json["center"].map((x) => x.toDouble())),
        geometry: Geometry.fromJson(json["geometry"]),
        context:
            List<Context>.from(json["context"].map((x) => Context.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "place_type": List<dynamic>.from(placeType.map((x) => x)),
        "relevance": relevance,
        "properties": properties.toJson(),
        "text": text,
        "place_name": placeName,
        "bbox": bbox == null ? null : List<dynamic>.from(bbox.map((x) => x)),
        "center": List<dynamic>.from(center.map((x) => x)),
        "geometry": geometry.toJson(),
        "context": List<dynamic>.from(context.map((x) => x.toJson())),
      };
}

class Context {
  Context({
    this.id,
    this.wikidata,
    this.shortCode,
    this.text,
  });

  String id;
  String wikidata;
  String shortCode;
  String text;

  factory Context.fromJson(Map<String, dynamic> json) => Context(
        id: json["id"],
        wikidata: json["wikidata"],
        shortCode: json["short_code"] == null ? null : json["short_code"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "wikidata": wikidata,
        "short_code": shortCode == null ? null : shortCode,
        "text": text,
      };
}

class Geometry {
  Geometry({
    this.type,
    this.coordinates,
  });

  String type;
  List<double> coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}

class Properties {
  Properties({
    this.wikidata,
    this.foursquare,
    this.landmark,
    this.address,
    this.category,
    this.maki,
  });

  String wikidata;
  String foursquare;
  bool landmark;
  String address;
  String category;
  String maki;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        wikidata: json["wikidata"] == null ? null : json["wikidata"],
        foursquare: json["foursquare"] == null ? null : json["foursquare"],
        landmark: json["landmark"] == null ? null : json["landmark"],
        address: json["address"] == null ? null : json["address"],
        category: json["category"] == null ? null : json["category"],
        maki: json["maki"] == null ? null : json["maki"],
      );

  Map<String, dynamic> toJson() => {
        "wikidata": wikidata == null ? null : wikidata,
        "foursquare": foursquare == null ? null : foursquare,
        "landmark": landmark == null ? null : landmark,
        "address": address == null ? null : address,
        "category": category == null ? null : category,
        "maki": maki == null ? null : maki,
      };
}
