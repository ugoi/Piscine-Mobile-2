import 'package:ex01/models.dart';
import 'package:ex01/weatherService.dart';
import 'package:location/location.dart';

class WeatherRepository {
  final WeatherService weatherService;

  WeatherRepository({required this.weatherService});

  Location location = Location();

  Future<List<City>> getCities(String name) async {
    try {
      final openMeteoCities = await weatherService.getOpenMeteoCities(name);
      final cities = openMeteoCities.results
          ?.map((result) => City(
              name: result.name!,
              region: result.admin1!,
              country: result.country!,
              latitude: result.latitude!,
              longitude: result.longitude!))
          .toList();

      return cities ?? [];
    } catch (e) {
      throw Exception('Failed to load cities');
    }
  }

  Future<WeatherData> getWeatherData(LocationData locationData) async {
    final openMeteoForecast =
        await weatherService.getOpenMeteoWeather(locationData);

    final today = <TodayWeatherData>[];
    for (var i = 0;
        i < (openMeteoForecast.daily?.temperature2MMax?.length ?? 0);
        i++) {
      today.add(TodayWeatherData(
          time: openMeteoForecast.hourly?.time?[i],
          temperature: openMeteoForecast.hourly?.temperature2M?[i],
          weatherCode: openMeteoForecast.hourly?.weatherCode?[i],
          windSpeed: openMeteoForecast.hourly?.windSpeed10M?[i]));
    }

    final currently = CurrentlyWeatherData(
        temperature: openMeteoForecast.current?.temperature2M,
        weatherCode: openMeteoForecast.current?.weatherCode,
        windSpeed: openMeteoForecast.current?.windSpeed10M);

    final weekly = <WeeklyWeatherData>[];
    for (var i = 0;
        i < (openMeteoForecast.daily?.temperature2MMax?.length ?? 0);
        i++) {
      weekly.add(WeeklyWeatherData(
          time: openMeteoForecast.daily?.time?[i],
          minTemperature: openMeteoForecast.daily?.temperature2MMin?[i],
          maxTemperature: openMeteoForecast.daily?.temperature2MMax?[i],
          weatherCode: openMeteoForecast.daily?.weatherCode?[i]));
    }

    final weatherData = WeatherData(
        city: City(
            name: "N/A",
            region: "N/A",
            country: "N/A",
            latitude: locationData.latitude,
            longitude: locationData.longitude),
        currently: currently,
        today: today,
        weekly: weekly);

    return weatherData;
  }
}
