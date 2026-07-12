import 'package:core/core.dart';
import '../../domain/models/weather_data.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/remote/service/open_weather_api_service.dart';
import '../mappers/weather_mapper.dart';
import '../models/remote/weather_model.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final OpenWeatherApiService _apiService;
  final String _apiKey;

  WeatherRepositoryImpl(this._apiService, this._apiKey);

  @override
  Future<WeatherData> getWeather(String cityName) async {
    try {
      final responseJson = await _apiService.getWeatherByCity(
        cityName: cityName,
        apiKey: _apiKey,
      );
      
      final weatherModel = Weather.fromJson(responseJson as Map<String, dynamic>);
      return weatherModel.toDomain();
    } catch (e) {
      throw ApiExceptionHandler.handleException(e);
    }
  }
}
