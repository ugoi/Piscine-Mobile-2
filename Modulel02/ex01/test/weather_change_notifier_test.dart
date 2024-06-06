import 'package:ex01/models.dart';
import 'package:ex01/weatherChangeNotifier.dart';
import 'package:ex01/weatherRepository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;


class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockClient extends Mock implements http.Client {}

class MockLocation extends Mock implements Location {}

void main() {
  late WeatherChangeNotifier sut;
  late MockWeatherRepository mockWeatherRepository;
  late MockLocation mockLocation;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    sut = WeatherChangeNotifier(weatherRepository: mockWeatherRepository);
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
    when(() => mockWeatherRepository.location).thenReturn(mockLocation);
  }

  void mockWeatherServiceLocationEnabled() {
    mockLocationEnabled();
    when(() => mockWeatherRepository.location).thenReturn(mockLocation);
  }

  void mockWeatherServiceLocationEnabledWithDelayedLocation() {
    mockLocationEnabledWithDelayedLocation();
    when(() => mockWeatherRepository.location).thenReturn(mockLocation);
  }

  group('searchCities', () {
    final cities = <City>[];

    cities.add(City(
        name: "Paris",
        region: "Ile-de-France",
        country: "France",
        latitude: 1,
        longitude: 1));
    cities.add(City(
        name: "London",
        region: "England",
        country: "United Kingdom",
        latitude: 1,
        longitude: 1));
    cities.add(City(
        name: "New York",
        region: "New York",
        country: "United States",
        latitude: 1,
        longitude: 1));

    void arrangeWeatherServiceReturns3Cities() {
      when(() => mockWeatherRepository.getCities("Par")).thenAnswer(
        (_) async => cities,
      );
    }

    test(
      "gets cities using the WeatherService",
      () async {
        arrangeWeatherServiceReturns3Cities();
        await sut.searchCities("Par");
        verify(() => mockWeatherRepository.getCities("Par")).called(1);
      },
    );

    test(
      """sets the cities to the result of the WeatherService
      when the search is successful""",
      () async {
        arrangeWeatherServiceReturns3Cities();

        await sut.searchCities("Par");
        final result = await sut.cities;
        expect(result, cities);
      },
    );

    test("on city selected", () {
      final city = City(
          name: "Paris",
          region: "Ille",
          country: "France",
          latitude: 1,
          longitude: 1);
      sut.onCitySelected(city);
      expect(sut.displayLocation, "Paris");
    });
  });

  group('test location', () {
    test(
      "initial values are correct",
      () {
        expect(sut.displayLocation, "");
        expect(sut.isLocationEnabled, null);
      },
    );

    test(
      "Location is not enabled",
      () {
        mockWeatherServiceLocationDisabled();
        expect(sut.isLocationEnabled, null);
      },
    );

    test(
      "Location is enabled",
      () async {
        mockWeatherServiceLocationEnabled();
        await sut.requestLocationPermission();
        expect(await sut.isLocationEnabled, true);
      },
    );
  });
}
