import 'package:core/core.dart';
import '../models/weather_data.dart';
import '../repositories/weather_repository.dart';

@injectable
class GetWeatherUseCase {
  final WeatherRepository _repository;

  GetWeatherUseCase(this._repository);

  Future<WeatherData> execute(String cityName) {
    return _repository.getWeather(cityName);
  }
}
