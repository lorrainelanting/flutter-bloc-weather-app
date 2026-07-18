import 'package:core/core.dart';

class WeatherData extends Equatable {
  final String city;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final List<Forecast> forecasts;

  const WeatherData({
    required this.city,
    required this.temperature,
    required this.description,
    this.feelsLike = 0,
    this.humidity = 0,
    this.windSpeed = 0,
    this.icon = '',
    this.forecasts = const [],
  });

  @override
  List<Object?> get props => [
        city,
        temperature,
        feelsLike,
        humidity,
        windSpeed,
        description,
        icon,
        forecasts,
      ];
}

class Forecast extends Equatable {
  final DateTime date;
  final String day;
  final double minTemp;
  final double maxTemp;
  final String description;
  final String icon;

  const Forecast({
    required this.date,
    required this.day,
    required this.minTemp,
    required this.maxTemp,
    required this.description,
    required this.icon,
  });

  @override
  List<Object?> get props => [date, day, minTemp, maxTemp, description, icon];
}
