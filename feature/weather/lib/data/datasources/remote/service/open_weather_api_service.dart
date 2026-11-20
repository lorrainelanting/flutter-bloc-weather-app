import 'package:core/core.dart';

@injectable
class OpenWeatherApiService {
  final BaseApiClient _client;

  OpenWeatherApiService(this._client);

  Future<dynamic> searchLocations({
    required String query,
    required String apiKey,
  }) async {
    final response = await _client.get(
      'geo/1.0/direct',
      queryParameters: {'q': query, 'limit': 5, 'appid': apiKey},
    );

    return response.data;
  }

  Future<dynamic> getWeatherByCity({
    required String cityName,
    required String apiKey,
  }) async {
    final response = await _client.get(
      'data/2.5/weather',
      queryParameters: {'q': cityName, 'appid': apiKey, 'units': 'metric'},
    );

    return response.data;
  }

  Future<dynamic> getWeatherByCoords({
    required double lat,
    required double lon,
    required String apiKey,
  }) async {
    final response = await _client.get(
      'data/2.5/weather',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': apiKey,
        'units': 'metric',
      },
    );

    return response.data;
  }

  Future<dynamic> getForecastByCoords({
    required double lat,
    required double lon,
    required String apiKey,
  }) async {
    final response = await _client.get(
      'data/2.5/forecast',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': apiKey,
        'units': 'metric',
      },
    );

    return response.data;
  }
}
