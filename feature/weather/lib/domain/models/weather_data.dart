import 'package:equatable/equatable.dart';

class WeatherData extends Equatable {
  final String city;
  final double temperature;
  final String description;

  const WeatherData({
    required this.city,
    required this.temperature,
    required this.description,
  });

  @override
  List<Object?> get props => [city, temperature, description];
}
