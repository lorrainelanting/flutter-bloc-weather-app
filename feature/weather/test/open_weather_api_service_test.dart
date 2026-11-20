import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather/data/datasources/remote/service/open_weather_api_service.dart';

class _RequestCaptureInterceptor extends Interceptor {
  final List<RequestOptions> requests = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    requests.add(options);
    handler.resolve(Response(requestOptions: options, data: <dynamic>[]));
  }
}

void main() {
  group('OpenWeatherApiService', () {
    late _RequestCaptureInterceptor interceptor;
    late OpenWeatherApiService service;

    setUp(() {
      interceptor = _RequestCaptureInterceptor();
      service = OpenWeatherApiService(
        BaseApiClient(
          baseUrl: 'https://api.openweathermap.org',
          interceptors: [interceptor],
        ),
      );
    });

    test(
      'uses the OpenWeather geocoding path relative to the configured host',
      () async {
        await service.searchLocations(query: 'London', apiKey: 'key');

        final request = interceptor.requests.single;
        expect(request.uri.host, 'api.openweathermap.org');
        expect(request.uri.path, '/geo/1.0/direct');
        expect(request.queryParameters, {
          'q': 'London',
          'limit': 5,
          'appid': 'key',
        });
      },
    );

    test('uses the data API paths relative to the configured host', () async {
      await service.getWeatherByCity(cityName: 'London', apiKey: 'key');
      await service.getWeatherByCoords(lat: 51.5, lon: -0.1, apiKey: 'key');
      await service.getForecastByCoords(lat: 51.5, lon: -0.1, apiKey: 'key');

      expect(
        interceptor.requests.map((request) => request.uri.path),
        [
          '/data/2.5/weather',
          '/data/2.5/weather',
          '/data/2.5/forecast',
        ],
      );
    });
  });
}
