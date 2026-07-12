import '../../domain/models/weather_data.dart';
import '../models/remote/weather_model.dart';

extension WeatherMapper on Weather {
  WeatherData toDomain() {
    return WeatherData(
      city: city,
      temperature: temperature,
      description: description,
    );
  }
}
