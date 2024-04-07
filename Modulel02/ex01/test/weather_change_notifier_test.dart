import 'package:ex01/models.dart';
import 'package:ex01/weatherChangeNotifier.dart';
import 'package:ex01/weatherService.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherService extends Mock implements WeatherService {}

class MockLocation extends Mock implements Location {}

void main() {
  late WeatherChangeNotifier sut;
  late MockWeatherService mockWeatherService;
  late MockLocation mockLocation;

  setUp(() {
    mockWeatherService = MockWeatherService();
    sut = WeatherChangeNotifier(mockWeatherService);
    mockLocation = MockLocation();
  });

  void mockLocationDisabled() {
    when(() => mockLocation.serviceEnabled()).thenAnswer((_) async => false);
    when(() => mockLocation.requestService()).thenAnswer((_) async => false);
    when(() => mockLocation.hasPermission())
        .thenAnswer((_) async => PermissionStatus.denied);
    when(() => mockLocation.requestPermission())
        .thenAnswer((_) async => PermissionStatus.denied);
    when(() => mockLocation.getLocation()).thenThrow(ArgumentError);
  }

  void mockLocationEnabled() {
    when(() => mockLocation.serviceEnabled()).thenAnswer((_) async => true);
    when(() => mockLocation.requestService()).thenAnswer((_) async => true);
    when(() => mockLocation.hasPermission())
        .thenAnswer((_) async => PermissionStatus.granted);
    when(() => mockLocation.requestPermission())
        .thenAnswer((_) async => PermissionStatus.granted);
    when(() => mockLocation.getLocation()).thenAnswer((_) async =>
        LocationData.fromMap({'latitude': 38.53, 'longitude': 77.02}));
  }

  void mockLocationEnabledWithDelayedLocation() {
    when(() => mockLocation.serviceEnabled()).thenAnswer((_) async => true);
    when(() => mockLocation.requestService()).thenAnswer((_) async => true);
    when(() => mockLocation.hasPermission())
        .thenAnswer((_) async => PermissionStatus.granted);
    when(() => mockLocation.requestPermission())
        .thenAnswer((_) async => PermissionStatus.granted);
    when(() => mockLocation.getLocation()).thenAnswer((_) async =>
        Future.delayed(Duration(seconds: 2), () {
          return LocationData.fromMap({'latitude': 38.53, 'longitude': 77.02});
        }));
  }

  void mockWeatherServiceLocationDisabled() {
    mockLocationDisabled();
    when(() => mockWeatherService.location).thenReturn(mockLocation);
  }

  void mockWeatherServiceLocationEnabled() {
    mockLocationEnabled();
    when(() => mockWeatherService.location).thenReturn(mockLocation);
  }

  void mockWeatherServiceLocationEnabledWithDelayedLocation() {
    mockLocationEnabledWithDelayedLocation();
    when(() => mockWeatherService.location).thenReturn(mockLocation);
  }

  test(
    "initial values are correct",
    () {
      expect(sut.cities, []);
    },
  );

  group('searchCities', () {
    final cities = <City>[];

    cities.add(City(name: "Paris", region: "Ile-de-France", country: "France"));
    cities.add(
        City(name: "London", region: "England", country: "United Kingdom"));
    cities.add(
        City(name: "New York", region: "New York", country: "United States"));

    void arrangeWeatherServiceReturns3Cities() {
      when(() => mockWeatherService.searchCities("Par")).thenAnswer(
        (_) async => cities,
      );
    }

    test(
      "gets cities using the WeatherService",
      () async {
        arrangeWeatherServiceReturns3Cities();
        await sut.searchCities("Par");
        verify(() => mockWeatherService.searchCities("Par")).called(1);
      },
    );

    test(
      """sets the cities to the result of the WeatherService
      when the search is successful""",
      () async {
        arrangeWeatherServiceReturns3Cities();
        await sut.searchCities("Par");
        expect(sut.cities, cities);
      },
    );
  });

  group('test location', () {
    test(
      "initial values are correct",
      () {
        expect(sut.displayLocation, "Loading location...");
        expect(sut.isLocationEnabled, false);
      },
    );

    test(
      "Location is not enabled",
      () {
        mockWeatherServiceLocationDisabled();
        expect(sut.isLocationEnabled, false);
      },
    );

    test(
      "Location is enabled",
      () async {
        mockWeatherServiceLocationEnabled();
        await sut.requestLocationPermission();
        expect(sut.isLocationEnabled, true);
      },
    );
  });
}
