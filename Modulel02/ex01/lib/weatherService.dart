import 'package:ex01/openMeteoCitiesJsonModel.dart';
import 'package:ex01/openMeteoForecastJsonModel.dart';
import 'package:ex01/models.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  final http.Client httpClient;

  WeatherService({required this.httpClient});

  Location location = Location();

  Future<OpenMeteoCities> getOpenMeteoCities(String name) async {
    // final cities = <City>[];
    // cities.add(City(name: "Paris", region: "Île-de-France", country: "France"));
    // cities.add(City(name: "Par", region: "England", country: "United Kingdom"));
    // cities.add(City(name: "Par", region: "Van", country: "Turkey"));

    final response = await httpClient.get(Uri.parse(
        "https://geocoding-api.open-meteo.com/v1/search?name=$name&count=10&language=en&format=json"));

    if (response.statusCode != 200) {
      throw Exception('Failed to load cities');
    }

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      final OpenMeteoCities openMeteoCities =
          openMeteoCitiesFromJson(response.body);

      final OpenMeteoCities filteredOpenMeteoCities = OpenMeteoCities(
          results: openMeteoCities.results
              ?.where((element) =>
                  element.name != null &&
                  element.admin1 != null &&
                  element.country != null &&
                  element.latitude != null &&
                  element.longitude != null)
              .toList(),
          generationtimeMs: openMeteoCities.generationtimeMs);

      return filteredOpenMeteoCities;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<OpenMeteoForecast> getOpenMeteoWeather(
      LocationData locationData) async {
    final response = await httpClient.get(Uri.parse(
        "https://api.open-meteo.com/v1/forecast?latitude=${locationData.latitude}&longitude=${locationData.longitude}&daily=5&hourly=24"));

    if (response.statusCode != 200) {
      throw Exception('Failed to load weather data');
    }

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      final Map<String, dynamic> results = jsonDecode(response.body);
      final weatherData = OpenMeteoForecast.fromJson(results);
      return weatherData;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
