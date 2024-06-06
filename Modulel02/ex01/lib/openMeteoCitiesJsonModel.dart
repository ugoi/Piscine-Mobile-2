// To parse this JSON data, do
//
//     final openMeteoCities = openMeteoCitiesFromJson(jsonString);

import 'dart:convert';


OpenMeteoCities openMeteoCitiesFromJson(String str) => OpenMeteoCities.fromJson(json.decode(str));

String openMeteoCitiesToJson(OpenMeteoCities data) => json.encode(data.toJson());

class OpenMeteoCities {
    List<Result>? results;
    double? generationtimeMs;

    OpenMeteoCities({
        this.results,
        this.generationtimeMs,
    });

    factory OpenMeteoCities.fromJson(Map<String, dynamic> json) => OpenMeteoCities(
        results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
        generationtimeMs: json["generationtime_ms"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
        "generationtime_ms": generationtimeMs,
    };
}

class Result {
    int? id;
    String? name;
    double? latitude;
    double? longitude;
    double? elevation;
    String? featureCode;
    String? countryCode;
    int? admin1Id;
    int? admin2Id;
    String? timezone;
    int? population;
    List<String>? postcodes;
    int? countryId;
    String? country;
    String? admin1;
    String? admin2;
    int? admin3Id;
    String? admin3;

    Result({
        this.id,
        this.name,
        this.latitude,
        this.longitude,
        this.elevation,
        this.featureCode,
        this.countryCode,
        this.admin1Id,
        this.admin2Id,
        this.timezone,
        this.population,
        this.postcodes,
        this.countryId,
        this.country,
        this.admin1,
        this.admin2,
        this.admin3Id,
        this.admin3,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"]!,
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        elevation: json["elevation"],
        featureCode: json["feature_code"]!,
        countryCode: json["country_code"],
        admin1Id: json["admin1_id"],
        admin2Id: json["admin2_id"],
        timezone: json["timezone"],
        population: json["population"],
        postcodes: json["postcodes"] == null ? [] : List<String>.from(json["postcodes"]!.map((x) => x)),
        countryId: json["country_id"],
        country: json["country"],
        admin1: json["admin1"],
        admin2: json["admin2"],
        admin3Id: json["admin3_id"],
        admin3: json["admin3"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "elevation": elevation,
        "feature_code": featureCode,
        "country_code": countryCode,
        "admin1_id": admin1Id,
        "admin2_id": admin2Id,
        "timezone": timezone,
        "population": population,
        "postcodes": postcodes == null ? [] : List<dynamic>.from(postcodes!.map((x) => x)),
        "country_id": countryId,
        "country": country,
        "admin1": admin1,
        "admin2": admin2,
        "admin3_id": admin3Id,
        "admin3": admin3,
    };
}
