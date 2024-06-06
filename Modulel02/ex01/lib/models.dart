import 'package:ex01/openMeteoForecastJsonModel.dart';

class WeatherCode {
  final int code;

  // Make code optional and add default value
  WeatherCode(int? code) : code = code ?? 0;

  String description() {
    switch (code) {
      case 80:
        return 'tornado';
      case 200:
        return 'thunderstorm with light rain';
      case 201:
        return 'thunderstorm with rain';
      case 202:
        return 'thunderstorm with heavy rain';
      case 210:
        return 'light thunderstorm';
      case 211:
        return 'thunderstorm';
      case 212:
        return 'heavy thunderstorm';
      case 221:
        return 'ragged thunderstorm';
      case 230:
        return 'thunderstorm with light drizzle';
      case 231:
        return 'thunderstorm with drizzle';
      case 232:
        return 'thunderstorm with heavy drizzle';
      case 300:
        return 'light intensity drizzle';
      case 301:
        return 'drizzle';
      case 302:
        return 'heavy intensity drizzle';
      case 310:
        return 'light intensity drizzle rain';
      case 311:
        return 'drizzle rain';
      case 312:
        return 'heavy intensity drizzle rain';
      case 313:
        return 'shower rain and drizzle';
      case 314:
        return 'heavy shower rain and drizzle';
      case 321:
        return 'shower drizzle';
      case 500:
        return 'light rain';
      case 501:
        return 'moderate rain';
      case 502:
        return 'heavy intensity rain';
      case 503:
        return 'very heavy rain';
      case 504:
        return 'extreme rain';
      case 511:
        return 'freezing rain';
      case 520:
        return 'light intensity shower rain';
      case 521:
        return 'shower rain';
      case 522:
        return 'heavy intensity shower rain';
      case 531:
        return 'ragged shower rain';
      case 600:
        return 'light snow';
      case 601:
        return 'snow';
      case 602:
        return 'heavy snow';
      case 611:
        return 'sleet';
      case 612:
        return 'shower sleet';
      case 613:
        return 'light rain and snow';
      case 615:
        return 'light rain and snow';
      case 616:
        return 'rain and snow';
      case 620:
        return 'light shower snow';
      case 621:
        return 'shower snow';
      case 622:
        return 'heavy shower snow';
      case 701:
        return 'mist';
      case 711:
        return 'smoke';
      case 721:
        return 'haze';
      case 731:
        return 'sand, dust whirls';
      case 741:
        return 'fog';
      case 751:
        return 'sand';
      case 761:
        return 'dust';
      case 762:
        return 'volcanic ash';
      case 771:
        return 'squalls';
      case 781:
        return 'tornado';
      default:
        return code.toString();
    }
  }
}

class WeatherData {
  final City? city;
  final CurrentlyWeatherData? currently;
  final List<TodayWeatherData>? today;
  final List<WeeklyWeatherData>? weekly;

  WeatherData({this.city, this.currently, this.today, this.weekly});
}

class CurrentlyWeatherData {
  final double? temperature;
  final WeatherCode? weatherCode;
  final double? windSpeed;

  CurrentlyWeatherData({this.temperature, this.weatherCode, this.windSpeed});
}

class TodayWeatherData {
  final DateTime? time;
  final double? temperature;
  final WeatherCode? weatherCode;
  final double? windSpeed;

  TodayWeatherData(
      {this.time, this.temperature, this.weatherCode, this.windSpeed});
}

class WeeklyWeatherData {
  final DateTime? time;
  final double? minTemperature;
  final double? maxTemperature;
  final WeatherCode? weatherCode;

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
