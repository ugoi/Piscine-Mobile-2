import 'package:ex01/models.dart';
import 'package:ex01/openMeteoCitiesJsonModel.dart';
import 'package:ex01/openMeteoForecastJsonModel.dart';
import 'package:ex01/weatherRepository.dart';
import 'package:ex01/weatherService.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherService extends Mock implements WeatherService {}

class MockLocation extends Mock implements Location {}

class MockLocationData extends Mock implements LocationData {}

void main() {
  late WeatherRepository weatherRepository;
  late MockWeatherService mockWeatherService;
  late MockLocation mockLocation;
  late MockLocationData mockLocationData;

  setUp(() {
    mockWeatherService = MockWeatherService();
    weatherRepository = WeatherRepository(weatherService: mockWeatherService);
    mockLocation = MockLocation();
    weatherRepository.location = mockLocation;
    mockLocationData = MockLocationData();
  });

  setUpAll(() => {
    registerFallbackValue(MockLocationData()),
  });

  group('WeatherRepository', () {
    test('getCities returns a list of City objects', () async {
      final cities = [
        Result(
            name: 'Paris',
            admin1: 'Île-de-France',
            country: 'France',
            latitude: 48.8566,
            longitude: 2.3522),
        Result(
            name: 'London',
            admin1: 'England',
            country: 'United Kingdom',
            latitude: 51.5074,
            longitude: -0.1278),
      ];

      when(() => mockWeatherService.getOpenMeteoCities(any()))
          .thenAnswer((_) async => OpenMeteoCities(results: cities));

      final result = await weatherRepository.getCities('Par');

      expect(result, isA<List<City>>());
      expect(result.length, 2);
      expect(result[0].name, 'Paris');
    });

    test('getCities throws an exception on error', () async {
      when(() => mockWeatherService.getOpenMeteoCities(any()))
          .thenThrow(Exception('Failed to load cities'));

      expect(() async => await weatherRepository.getCities('Par'),
          throwsException);
    });

    test('getWeatherData returns WeatherData object', () async {
      final forecast = OpenMeteoForecast(
        current: Current(
          temperature2M: 20.0,
          weatherCode: 1,
          windSpeed10M: 5.0,
          time: DateTime.now(),
          interval: 3600,
        ),
        hourly: Hourly(
          time: [DateTime.now()],
          temperature2M: [20.0],
          weatherCode: [1],
          windSpeed10M: [5.0],
        ),
        daily: Daily(
          time: [DateTime.now()],
          weatherCode: [1],
          temperature2MMax: [25.0],
          temperature2MMin: [15.0],
        ),
      );

      when(() => mockWeatherService.getOpenMeteoWeather(any()))
          .thenAnswer((_) async => forecast);

      when(() => mockLocationData.latitude).thenReturn(48.8566);
      when(() => mockLocationData.longitude).thenReturn(2.3522);

      final result = await weatherRepository.getWeatherData(mockLocationData);

      expect(result, isA<WeatherData>());
      expect(result.currently?.temperature, 20.0);
    });

    test('getWeatherData throws an exception on error', () async {
      when(() => mockWeatherService.getOpenMeteoWeather(any()))
          .thenThrow(Exception('Failed to load weather data'));

      expect(
          () async => await weatherRepository.getWeatherData(mockLocationData),
          throwsException);
    });
  });
}
