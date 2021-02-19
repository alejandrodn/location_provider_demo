// To parse this JSON data, do
//
//     final reverseGeocodingResponse = reverseGeocodingResponseFromJson(jsonString);

import 'dart:convert';

ReverseGeocodingResponse reverseGeocodingResponseFromJson(String str) =>
    ReverseGeocodingResponse.fromJson(json.decode(str));

String reverseGeocodingResponseToJson(ReverseGeocodingResponse data) =>
    json.encode(data.toJson());

class ReverseGeocodingResponse {
  ReverseGeocodingResponse({
    this.type,
    this.query,
    this.features,
    this.attribution,
  });

  String type;
  List<double> query;
  List<Feature> features;
  String attribution;

  factory ReverseGeocodingResponse.fromJson(Map<String, dynamic> json) =>
      ReverseGeocodingResponse(
        type: json["type"],
        query: List<double>.from(json["query"].map((x) => x.toDouble())),
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
    this.textEs,
    this.placeNameEs,
    this.text,
    this.placeName,
    this.center,
    this.geometry,
    this.context,
    this.bbox,
    this.languageEs,
    this.language,
  });

  String id;
  String type;
  List<String> placeType;
  int relevance;
  Properties properties;
  String textEs;
  String placeNameEs;
  String text;
  String placeName;
  List<double> center;
  Geometry geometry;
  List<Context> context;
  List<double> bbox;
  String languageEs;
  String language;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        type: json["type"],
        placeType: List<String>.from(json["place_type"].map((x) => x)),
        relevance: json["relevance"],
        properties: Properties.fromJson(json["properties"]),
        textEs: json["text_es"],
        placeNameEs: json["place_name_es"],
        text: json["text"],
        placeName: json["place_name"],
        center: List<double>.from(json["center"].map((x) => x.toDouble())),
        geometry: Geometry.fromJson(json["geometry"]),
        context: json["context"] == null
            ? null
            : List<Context>.from(
                json["context"].map((x) => Context.fromJson(x))),
        bbox: json["bbox"] == null
            ? null
            : List<double>.from(json["bbox"].map((x) => x.toDouble())),
        languageEs: json["language_es"] == null ? null : json["language_es"],
        language: json["language"] == null ? null : json["language"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "place_type": List<dynamic>.from(placeType.map((x) => x)),
        "relevance": relevance,
        "properties": properties.toJson(),
        "text_es": textEs,
        "place_name_es": placeNameEs,
        "text": text,
        "place_name": placeName,
        "center": List<dynamic>.from(center.map((x) => x)),
        "geometry": geometry.toJson(),
        "context": context == null
            ? null
            : List<dynamic>.from(context.map((x) => x.toJson())),
        "bbox": bbox == null ? null : List<dynamic>.from(bbox.map((x) => x)),
        "language_es": languageEs == null ? null : languageEs,
        "language": language == null ? null : language,
      };
}

class Context {
  Context({
    this.id,
    this.textEs,
    this.text,
    this.wikidata,
    this.languageEs,
    this.language,
    this.shortCode,
  });

  String id;
  String textEs;
  String text;
  String wikidata;
  String languageEs;
  String language;
  String shortCode;

  factory Context.fromJson(Map<String, dynamic> json) => Context(
        id: json["id"],
        textEs: json["text_es"],
        text: json["text"],
        wikidata: json["wikidata"] == null ? null : json["wikidata"],
        languageEs: json["language_es"] == null ? null : json["language_es"],
        language: json["language"] == null ? null : json["language"],
        shortCode: json["short_code"] == null ? null : json["short_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text_es": textEs,
        "text": text,
        "wikidata": wikidata == null ? null : wikidata,
        "language_es": languageEs == null ? null : languageEs,
        "language": language == null ? null : language,
        "short_code": shortCode == null ? null : shortCode,
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
    this.accuracy,
    this.wikidata,
    this.shortCode,
  });

  String accuracy;
  String wikidata;
  String shortCode;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        accuracy: json["accuracy"] == null ? null : json["accuracy"],
        wikidata: json["wikidata"] == null ? null : json["wikidata"],
        shortCode: json["short_code"] == null ? null : json["short_code"],
      );

  Map<String, dynamic> toJson() => {
        "accuracy": accuracy == null ? null : accuracy,
        "wikidata": wikidata == null ? null : wikidata,
        "short_code": shortCode == null ? null : shortCode,
      };
}
