// Generated with https://app.quicktype.io
// To parse this JSON data, do
//
//     final openMeteoForecast = openMeteoForecastFromJson(jsonString);

import 'dart:convert';

OpenMeteoForecast openMeteoForecastFromJson(String str) =>
    OpenMeteoForecast.fromJson(json.decode(str));

String openMeteoForecastToJson(OpenMeteoForecast data) =>
    json.encode(data.toJson());

class OpenMeteoForecast {
  double? latitude;
  double? longitude;
  double? generationtimeMs;
  int? utcOffsetSeconds;
  String? timezone;
  String? timezoneAbbreviation;
  int? elevation;
  Units? currentUnits;
  Current? current;
  Units? hourlyUnits;
  Hourly? hourly;
  DailyUnits? dailyUnits;
  Daily? daily;

  OpenMeteoForecast({
    this.latitude,
    this.longitude,
    this.generationtimeMs,
    this.utcOffsetSeconds,
    this.timezone,
    this.timezoneAbbreviation,
    this.elevation,
    this.currentUnits,
    this.current,
    this.hourlyUnits,
    this.hourly,
    this.dailyUnits,
    this.daily,
  });

  factory OpenMeteoForecast.fromJson(Map<String, dynamic> json) =>
      OpenMeteoForecast(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        generationtimeMs: json["generationtime_ms"]?.toDouble(),
        utcOffsetSeconds: json["utc_offset_seconds"],
        timezone: json["timezone"],
        timezoneAbbreviation: json["timezone_abbreviation"],
        elevation: json["elevation"],
        currentUnits: json["current_units"] == null
            ? null
            : Units.fromJson(json["current_units"]),
        current:
            json["current"] == null ? null : Current.fromJson(json["current"]),
        hourlyUnits: json["hourly_units"] == null
            ? null
            : Units.fromJson(json["hourly_units"]),
        hourly: json["hourly"] == null ? null : Hourly.fromJson(json["hourly"]),
        dailyUnits: json["daily_units"] == null
            ? null
            : DailyUnits.fromJson(json["daily_units"]),
        daily: json["daily"] == null ? null : Daily.fromJson(json["daily"]),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "generationtime_ms": generationtimeMs,
        "utc_offset_seconds": utcOffsetSeconds,
        "timezone": timezone,
        "timezone_abbreviation": timezoneAbbreviation,
        "elevation": elevation,
        "current_units": currentUnits?.toJson(),
        "current": current?.toJson(),
        "hourly_units": hourlyUnits?.toJson(),
        "hourly": hourly?.toJson(),
        "daily_units": dailyUnits?.toJson(),
        "daily": daily?.toJson(),
      };
}

class Current {
  DateTime? time;
  int? interval;
  double? temperature2M;
  int? weatherCode;
  double? windSpeed10M;

  Current({
    this.time,
    this.interval,
    this.temperature2M,
    this.weatherCode,
    this.windSpeed10M,
  });

  factory Current.fromJson(Map<String, dynamic> json) => Current(
        time: DateTime.parse(json["time"]),
        interval: json["interval"],
        temperature2M: json["temperature_2m"]?.toDouble(),
        weatherCode: json["weather_code"],
        windSpeed10M: json["wind_speed_10m"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "interval": interval,
        "temperature_2m": temperature2M,
        "weather_code": weatherCode,
        "wind_speed_10m": windSpeed10M,
      };
}

class Units {
  String? time;
  String? interval;
  String? temperature2M;
  String? weatherCode;
  String? windSpeed10M;

  Units({
    this.time,
    this.interval,
    this.temperature2M,
    this.weatherCode,
    this.windSpeed10M,
  });

  factory Units.fromJson(Map<String, dynamic> json) => Units(
        time: json["time"],
        interval: json["interval"],
        temperature2M: json["temperature_2m"],
        weatherCode: json["weather_code"],
        windSpeed10M: json["wind_speed_10m"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "interval": interval,
        "temperature_2m": temperature2M,
        "weather_code": weatherCode,
        "wind_speed_10m": windSpeed10M,
      };
}

class Daily {
  List<DateTime>? time;
  List<int>? weatherCode;
  List<double>? temperature2MMax;
  List<double>? temperature2MMin;

  Daily({
    this.time,
    this.weatherCode,
    this.temperature2MMax,
    this.temperature2MMin,
  });

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
        time: json["time"] == null
            ? []
            : List<DateTime>.from(json["time"]!.map((x) => DateTime.parse(x))),
        weatherCode: json["weather_code"] == null
            ? []
            : List<int>.from(json["weather_code"]!.map((x) => x)),
        temperature2MMax: json["temperature_2m_max"] == null
            ? []
            : List<double>.from(
                json["temperature_2m_max"]!.map((x) => x?.toDouble())),
        temperature2MMin: json["temperature_2m_min"] == null
            ? []
            : List<double>.from(
                json["temperature_2m_min"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "time": time == null
            ? []
            : List<dynamic>.from(time!.map((x) =>
                "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
        "weather_code": weatherCode == null
            ? []
            : List<dynamic>.from(weatherCode!.map((x) => x)),
        "temperature_2m_max": temperature2MMax == null
            ? []
            : List<dynamic>.from(temperature2MMax!.map((x) => x)),
        "temperature_2m_min": temperature2MMin == null
            ? []
            : List<dynamic>.from(temperature2MMin!.map((x) => x)),
      };
}

class DailyUnits {
  String? time;
  String? weatherCode;
  String? temperature2MMax;
  String? temperature2MMin;

  DailyUnits({
    this.time,
    this.weatherCode,
    this.temperature2MMax,
    this.temperature2MMin,
  });

  factory DailyUnits.fromJson(Map<String, dynamic> json) => DailyUnits(
        time: json["time"],
        weatherCode: json["weather_code"],
        temperature2MMax: json["temperature_2m_max"],
        temperature2MMin: json["temperature_2m_min"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "weather_code": weatherCode,
        "temperature_2m_max": temperature2MMax,
        "temperature_2m_min": temperature2MMin,
      };
}

class Hourly {
  List<DateTime>? time;
  List<double>? temperature2M;
  List<int>? weatherCode;
  List<double>? windSpeed10M;

  Hourly({
    this.time,
    this.temperature2M,
    this.weatherCode,
    this.windSpeed10M,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
        time: json["time"] == null
            ? []
            : List<DateTime>.from(json["time"]!.map((x) => DateTime.parse(x))),
        temperature2M: json["temperature_2m"] == null
            ? []
            : List<double>.from(
                json["temperature_2m"]!.map((x) => x?.toDouble())),
        weatherCode: json["weather_code"] == null
            ? []
            : List<int>.from(json["weather_code"]!.map((x) => x)),
        windSpeed10M: json["wind_speed_10m"] == null
            ? []
            : List<double>.from(
                json["wind_speed_10m"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "time": time == null ? [] : List<dynamic>.from(time!.map((x) => x)),
        "temperature_2m": temperature2M == null
            ? []
            : List<dynamic>.from(temperature2M!.map((x) => x)),
        "weather_code": weatherCode == null
            ? []
            : List<dynamic>.from(weatherCode!.map((x) => x)),
        "wind_speed_10m": windSpeed10M == null
            ? []
            : List<dynamic>.from(windSpeed10M!.map((x) => x)),
      };
}
