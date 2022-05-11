// To parse this JSON data, do
//
//     final citySearchModel = citySearchModelFromJson(jsonString);

import 'dart:convert';

List<CitySearchModel> citySearchModelFromJson(String str) =>
    List<CitySearchModel>.from(
        json.decode(str).map((x) => CitySearchModel.fromJson(x)));

class CitySearchModel {
  CitySearchModel({
    this.id,
    this.geonameId,
    this.type,
    this.name,
    this.population,
    this.elevation,
    this.timezoneId,
    this.country,
    this.adminDivision1,
    this.adminDivision2,
    this.score,
    this.coordinates,
  });

  String? id;
  int? geonameId;
  String? type;
  String? name;
  int? population;
  int? elevation;
  String? timezoneId;
  AdminDivision1? country;
  AdminDivision1? adminDivision1;
  AdminDivision1? adminDivision2;
  double? score;
  Coordinates? coordinates;

  factory CitySearchModel.fromJson(Map<String, dynamic> json) =>
      CitySearchModel(
        id: json["id"],
        geonameId: json["geonameId"],
        type: json["type"],
        name: json["name"],
        population: json["population"],
        elevation: json["elevation"],
        timezoneId: json["timezoneId"],
        country: AdminDivision1.fromJson(json["country"]),
        score: json["score"].toDouble(),
        coordinates: Coordinates.fromJson(json["coordinates"]),
      );
}

class AdminDivision1 {
  AdminDivision1({
    this.id,
    this.geonameId,
    this.name,
  });

  String? id;
  int? geonameId;
  String? name;

  factory AdminDivision1.fromJson(Map<String, dynamic> json) => AdminDivision1(
        id: json["id"],
        geonameId: json["geonameId"],
        name: json["name"],
      );
}

class Coordinates {
  Coordinates({
    this.latitude,
    this.longitude,
  });

  double? latitude;
  double? longitude;

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
      );
}

enum TimezoneId { AMERICA_LOS_ANGELES, AMERICA_NEW_YORK, AMERICA_CHICAGO }
