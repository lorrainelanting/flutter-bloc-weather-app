import 'package:core/core.dart';

@injectable
class OpenWeatherApiService {
  final BaseApiClient _client;

  OpenWeatherApiService(this._client);

  Future<dynamic> getWeatherByCity({
    required String cityName,
    required String apiKey,
  }) async {
    final response = await _client.get(
      'weather',
      queryParameters: {
        'q': cityName,
        'appid': apiKey,
        'units': 'metric',
      },
    );

    return response.data;
  }

  Future<dynamic> getWeatherByCoords({
    required double lat,
    required double lon,
    required String apiKey,
  }) async {
    final response = await _client.get(
      'weather',
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
      'forecast',
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
