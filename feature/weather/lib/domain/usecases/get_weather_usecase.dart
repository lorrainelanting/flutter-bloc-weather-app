import '../models/weather_data.dart';
import '../repositories/weather_repository.dart';

class GetWeatherUseCase {
  final WeatherRepository _repository;

  GetWeatherUseCase(this._repository);

  Future<WeatherData> execute(String cityName) {
    return _repository.getWeather(cityName);
  }
}
