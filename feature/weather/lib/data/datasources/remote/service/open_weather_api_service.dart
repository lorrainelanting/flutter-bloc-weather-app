import 'package:core/core.dart';

class OpenWeatherApiService {
  final BaseApiClient _client;
  final String _baseUrl;

  OpenWeatherApiService(this._client, {String? baseUrl})
      : _baseUrl = baseUrl ?? "https://api.openweathermap.org/data/2.5/";

  Future<dynamic> getWeatherByCity({
    required String cityName,
    required String apiKey,
  }) async {
    final response = await _client.get(
      '${_baseUrl}weather',
      queryParameters: {
        'q': cityName,
        'appid': apiKey,
      },
    );

    return response.data;
  }
}
