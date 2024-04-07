import 'package:ex01/models.dart';
import 'package:location/location.dart';

class WeatherService {
  Location location = Location();

  Future<List<City>> searchCities(String name) async {
    final cities = <City>[];
    cities.add(
        City(name: "Pariss", region: "Ile-de-Francee", country: "Francee"));
    cities.add(
        City(name: "Londonn", region: "Englandd", country: "United Kingdomm"));
    cities.add(
        City(name: "New York", region: "New York", country: "United Statess"));
    return cities;
  }
}
