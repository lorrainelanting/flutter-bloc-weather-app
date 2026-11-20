import 'package:core/core.dart';
import '../../domain/models/saved_city.dart';
import '../../domain/models/weather_data.dart';
import '../../domain/models/weather_location.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/local/saved_cities_local_data_source.dart';
import '../datasources/remote/service/open_weather_api_service.dart';
import '../mappers/weather_mapper.dart';
import '../models/remote/forecast_response.dart';
import '../models/remote/weather_model.dart';

@Injectable(as: WeatherRepository)
class WeatherRepositoryImpl implements WeatherRepository {
  final OpenWeatherApiService _apiService;
  final AppConfig _appConfig;
  final SavedCitiesLocalDataSource _localDataSource;

  WeatherRepositoryImpl(
    this._apiService,
    this._appConfig,
    this._localDataSource,
  );

  @override
  Future<List<WeatherLocation>> searchLocations(String query) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.length < 2) return [];

    try {
      final response = await _apiService.searchLocations(
        query: normalizedQuery,
        apiKey: _appConfig.openWeatherApiKey,
      );
      if (response is! List) {
        throw const FormatException('Location search response is invalid');
      }

      return response.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Location search result is invalid');
        }
        return WeatherLocation(
          name: item['name'] as String,
          country: item['country'] as String? ?? '',
          state: item['state'] as String?,
          latitude: (item['lat'] as num).toDouble(),
          longitude: (item['lon'] as num).toDouble(),
        );
      }).toList();
    } catch (e) {
      throw ApiExceptionHandler.handleException(e);
    }
  }

  @override
  Future<List<SavedCity>> getSavedCities() {
    return _localDataSource.getSavedCities();
  }

  @override
  Future<void> saveLocation(WeatherLocation location) async {
    final cities = await _localDataSource.getSavedCities();
    if (cities.any((city) => city.location.id == location.id)) return;
    await _localDataSource.saveSavedCities([
      ...cities,
      SavedCity(location: location),
    ]);
  }

  @override
  Future<void> removeSavedCities(Set<String> locationIds) async {
    if (locationIds.isEmpty) return;
    final cities = await _localDataSource.getSavedCities();
    await _localDataSource.saveSavedCities(
      cities.where((city) => !locationIds.contains(city.location.id)).toList(),
    );
  }

  @override
  Future<void> cacheWeather(
    WeatherLocation location,
    WeatherData weather,
    DateTime cachedAt,
  ) async {
    final cities = await _localDataSource.getSavedCities();
    final index = cities.indexWhere((city) => city.location.id == location.id);
    if (index == -1) return;

    cities[index] = SavedCity(
      location: cities[index].location,
      cachedWeather: weather,
      cachedAt: cachedAt,
    );
    await _localDataSource.saveSavedCities(cities);
  }

  @override
  Future<WeatherData> getWeather(String cityName) async {
    try {
      final responseJson = await _apiService.getWeatherByCity(
        cityName: cityName,
        apiKey: _appConfig.openWeatherApiKey,
      );

      final weatherModel = Weather.fromJson(
        responseJson as Map<String, dynamic>,
      );
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
      final forecastResponse = ForecastResponse.fromJson(
        results[1] as Map<String, dynamic>,
      );

      return weatherModel.toDomain(
        forecasts: forecastResponse.toDailyForecasts(),
      );
    } catch (e) {
      throw ApiExceptionHandler.handleException(e);
    }
  }
}
