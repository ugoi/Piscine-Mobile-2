import 'dart:io';
import 'package:ex01/models.dart';
import 'package:ex01/weatherChangeNotifier.dart';
import 'package:ex01/weatherService.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {
  late WeatherService sut;
  late MockClient mockHttpClient;

  void mockClientSearchEqualsPar() {
    final file = File('test/resources/cities.json');
    when(() => mockHttpClient.get(Uri.parse(
            "https://geocoding-api.open-meteo.com/v1/search?name=Par&count=10&language=en&format=json")))
        .thenAnswer(
      (_) async => http.Response(await file.readAsString(), 200, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      }),
    );
  }

  void mockClientSearchEqualsLo() {
    final file = File('test/resources/cities_search_equals_lo.json');
    when(() => mockHttpClient.get(Uri.parse(
            "https://geocoding-api.open-meteo.com/v1/search?name=Lo&count=10&language=en&format=json")))
        .thenAnswer(
      (_) async => http.Response(await file.readAsString(), 200, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      }),
    );
  }

  void mockClientEmpty() {
    final file = File('test/resources/cities_empty.json');
    when(() => mockHttpClient.get(Uri.parse(
            "https://geocoding-api.open-meteo.com/v1/search?name=&count=10&language=en&format=json")))
        .thenAnswer(
      (_) async => http.Response(await file.readAsString(), 200, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      }),
    );
  }

  void mockClientWithNullValues() {
    final file = File('test/resources/cities_with_null_values.json');
    when(() => mockHttpClient.get(Uri.parse(
            "https://geocoding-api.open-meteo.com/v1/search?name=Par&count=10&language=en&format=json")))
        .thenAnswer(
      (_) async => http.Response(await file.readAsString(), 200, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      }),
    );
  }

  void mockGetWeatherData() {
    final file = File('test/resources/weather_data.json');
    when(() => mockHttpClient.get(Uri.parse(
            "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current=temperature_2m,weather_code,wind_speed_10m&hourly=temperature_2m,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=Europe%2FBerlin")))
        .thenAnswer(
      (_) async => http.Response(await file.readAsString(), 200, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      }),
    );
  }

  setUp(() {
    mockHttpClient = MockClient();
    sut = WeatherService(httpClient: mockHttpClient);
  });

  group('searchCities', () {
    final cities = <City>[];
    cities.add(City(
        name: "Paris",
        region: "Île-de-France",
        country: "France",
        longitude: 3,
        latitude: 4));
    cities.add(City(
        name: "Par",
        region: "England",
        country: "United Kingdom",
        longitude: 3,
        latitude: 4));
    cities.add(City(
        name: "Par",
        region: "West Azerbaijan",
        country: "Iran",
        longitude: 3,
        latitude: 4));

    final filtered_cities = <City>[];
    filtered_cities.add(City(
        name: "Par",
        region: "England",
        country: "United Kingdom",
        longitude: -4.70288,
        latitude: 50.35107));
    filtered_cities.add(City(
        name: "Par",
        region: "Van",
        country: "Turkey",
        longitude: 42.78333,
        latitude: 38.06667));

    test(
      "gets cities with search equals Par",
      () async {
        mockClientSearchEqualsPar();
        final result = await sut.getOpenMeteoCities("Par");
        expect(result.results?[0].id, 2988507);
      },
    );

//     test(
//       "gets cities with search equals lo",
//       () async {
//         final cities = <City>[];
//         cities.add(City(
//             name: "Lo",
//             region: "Flanders",
//             country: "Belgium",
//             longitude: 3,
//             latitude: 4));
//         mockClientSearchEqualsLo();
//         final result = await sut.searchCities("Lo");
//         expect(result[0], cities[0]);
//       },
//     );

//     test(
//       "gets cities with empty search",
//       () async {
//         mockClientEmpty();
//         final result = await sut.searchCities("");
//         expect(result, []);
//       },
//     );

//     test(
//       "gets filtered cities",
//       () async {
//         mockClientWithNullValues();
//         final result = await sut.searchCities("Par");
//         expect(result[0], filtered_cities[0]);
//         expect(result[1], filtered_cities[1]);
//       },
//     );
//   });

//   group('getWeatherData', () {
//     final city = City(
//         name: "Berlin",
//         region: "Berlin",
//         country: "Germany",
//         longitude: 13.41,
//         latitude: 52.52);

//     final currently = CurrentlyWeatherData(
//         temperature: 9.8, weatherCode: 4, windSpeed: 11.5);
//     final today = [
//       TodayWeatherData(
//           time: DateTime.now(),
//           temperature: 10.0,
//           weatherDescription: "Clear",
//           windSpeed: 2.0),
//       TodayWeatherData(
//           time: DateTime.now(),
//           temperature: 10.0,
//           weatherDescription: "Clear",
//           windSpeed: 2.0),
//       TodayWeatherData(
//           time: DateTime.now(),
//           temperature: 10.0,
//           weatherDescription: "Clear",
//           windSpeed: 2.0),
//       TodayWeatherData(
//           time: DateTime.now(),
//           temperature: 10.0,
//           weatherDescription: "Clear",
//           windSpeed: 2.0),
//       TodayWeatherData(
//           time: DateTime.now(),
//           temperature: 10.0,
//           weatherDescription: "Clear",
//           windSpeed: 2.0),
//       TodayWeatherData(
//           time: DateTime.now(),
//           temperature: 10.0,
//           weatherDescription: "Clear",
//           windSpeed: 2.0),
//       TodayWeatherData(
//           time: DateTime.now(),
//           temperature: 10.0,
//           weatherDescription: "Clear",
//           windSpeed: 2.0),
//       TodayWeatherData(
//           time: DateTime.now(),
//           temperature: 10.0,
//           weatherDescription: "Clear",
//           windSpeed: 2.0)
//     ];
//     final weekly = [
//       WeeklyWeatherData(
//           time: DateTime.now(),
//           minTemperature: 10.0,
//           maxTemperature: 20.0,
//           weatherDescription: "Clear"),
//       WeeklyWeatherData(
//           time: DateTime.now(),
//           minTemperature: 10.0,
//           maxTemperature: 20.0,
//           weatherDescription: "Clear"),
//       WeeklyWeatherData(
//           time: DateTime.now(),
//           minTemperature: 10.0,
//           maxTemperature: 20.0,
//           weatherDescription: "Clear"),
//       WeeklyWeatherData(
//           time: DateTime.now(),
//           minTemperature: 10.0,
//           maxTemperature: 20.0,
//           weatherDescription: "Clear"),
//       WeeklyWeatherData(
//           time: DateTime.now(),
//           minTemperature: 10.0,
//           maxTemperature: 20.0,
//           weatherDescription: "Clear"),
//       WeeklyWeatherData(
//           time: DateTime.now(),
//           minTemperature: 10.0,
//           maxTemperature: 20.0,
//           weatherDescription: "Clear"),
//       WeeklyWeatherData(
//           time: DateTime.now(),
//           minTemperature: 10.0,
//           maxTemperature: 20.0,
//           weatherDescription: "Clear"),
//       WeeklyWeatherData(
//           time: DateTime.now(),
//           minTemperature: 10.0,
//           maxTemperature: 20.0,
//           weatherDescription: "Clear")
//     ];
//     final weatherData = WeatherData(
//         city: city, currently: currently, today: today, weekly: weekly);

//     test(
//       "gets WeatherData",
//       () async {
//         mockGetWeatherData();
//         final result = await sut.getWeatherData();
//         expect(result, weatherData);
//       },
//     );
  });
}
