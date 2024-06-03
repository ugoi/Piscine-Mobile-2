import 'package:ex01/openMeteoForecastJsonModel.dart';

class WeatherData {
  final City? city;
  final CurrentlyWeatherData? currently;
  final List<TodayWeatherData>? today;
  final List<WeeklyWeatherData>? weekly;

  WeatherData({this.city, this.currently, this.today, this.weekly});
}

class CurrentlyWeatherData {
  final double? temperature;
  final int? weatherCode;
  final double? windSpeed;

  CurrentlyWeatherData({this.temperature, this.weatherCode, this.windSpeed});
}

class TodayWeatherData {
  final DateTime? time;
  final double? temperature;
  final int? weatherCode;
  final double? windSpeed;

  TodayWeatherData(
      {this.time, this.temperature, this.weatherCode, this.windSpeed});
}

class WeeklyWeatherData {
  final DateTime? time;
  final double? minTemperature;
  final double? maxTemperature;
  final int? weatherCode;

  WeeklyWeatherData(
      {this.time, this.minTemperature, this.maxTemperature, this.weatherCode});
}

class City {
  final String? name;
  final String? region;
  final String? country;
  final double? latitude;
  final double? longitude;

  City({this.name, this.region, this.country, this.latitude, this.longitude});

  @override
  bool operator ==(Object other) {
    if (other is City) {
      return name == other.name &&
          region == other.region &&
          country == other.country;
    }
    return false;
  }

  @override
  int get hashCode => name.hashCode ^ region.hashCode ^ country.hashCode;
}
