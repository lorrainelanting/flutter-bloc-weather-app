import 'package:core/core.dart';
import '../../domain/models/weather_data.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/remote/service/open_weather_api_service.dart';
import '../mappers/weather_mapper.dart';
import '../models/remote/forecast_response.dart';
import '../models/remote/weather_model.dart';

@Injectable(as: WeatherRepository)
class WeatherRepositoryImpl implements WeatherRepository {
  final OpenWeatherApiService _apiService;
  final AppConfig _appConfig;

  WeatherRepositoryImpl(
    this._apiService,
    this._appConfig,
  );

  @override
  Future<WeatherData> getWeather(String cityName) async {
    try {
      final responseJson = await _apiService.getWeatherByCity(
        cityName: cityName,
        apiKey: _appConfig.openWeatherApiKey,
      );

      final weatherModel = Weather.fromJson(responseJson as Map<String, dynamic>);
      return weatherModel.toDomain();
    } catch (e) {
      throw ApiExceptionHandler.handleException(e);
    }
  }

  @override
  Future<WeatherData> getWeatherByCoords(double lat, double lon) async {
    try {
      final apiKey = _appConfig.openWeatherApiKey;

      final results = await Future.wait([
        _apiService.getWeatherByCoords(lat: lat, lon: lon, apiKey: apiKey),
        _apiService.getForecastByCoords(lat: lat, lon: lon, apiKey: apiKey),
      ]);

      final weatherModel = Weather.fromJson(results[0] as Map<String, dynamic>);
      final forecastResponse = ForecastResponse.fromJson(results[1] as Map<String, dynamic>);

      return weatherModel.toDomain(forecasts: forecastResponse.toDailyForecasts());
    } catch (e) {
      throw ApiExceptionHandler.handleException(e);
    }
  }
}
