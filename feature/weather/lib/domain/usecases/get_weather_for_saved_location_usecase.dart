import 'package:core/core.dart';
import '../models/weather_data.dart';
import '../models/weather_location.dart';
import '../repositories/weather_repository.dart';

@injectable
class GetWeatherForSavedLocationUseCase {
  final WeatherRepository _repository;

  GetWeatherForSavedLocationUseCase(this._repository);

  Future<WeatherData> execute(WeatherLocation location) async {
    final weather = await _repository.getWeatherByCoords(
      location.latitude,
      location.longitude,
    );
    await _repository.cacheWeather(location, weather, DateTime.now());
    return weather;
  }
}
