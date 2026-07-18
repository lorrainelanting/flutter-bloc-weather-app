import 'package:flutter_test/flutter_test.dart';

import 'package:weather/data/mappers/weather_mapper.dart';
import 'package:weather/data/models/remote/forecast_response.dart';
import 'package:weather/data/models/remote/weather_model.dart';

void main() {
  group('Weather.fromJson', () {
    test('parses a sample OpenWeather current-weather payload', () {
      final json = {
        'name': 'London',
        'main': {
          'temp': 18.5,
          'feels_like': 17.9,
          'humidity': 72,
        },
        'wind': {'speed': 4.1},
        'weather': [
          {'description': 'light rain', 'icon': '10d'},
        ],
      };

      final weather = Weather.fromJson(json);

      expect(weather.city, 'London');
      expect(weather.temperature, 18.5);
      expect(weather.feelsLike, 17.9);
      expect(weather.humidity, 72);
      expect(weather.windSpeed, 4.1);
      expect(weather.description, 'light rain');
      expect(weather.icon, '10d');
    });

    test('defaults wind speed to 0 when the wind block is absent', () {
      final json = {
        'name': 'London',
        'main': {'temp': 18.5, 'feels_like': 17.9, 'humidity': 72},
        'weather': [
          {'description': 'clear sky', 'icon': '01d'},
        ],
      };

      final weather = Weather.fromJson(json);

      expect(weather.windSpeed, 0.0);
    });
  });

  group('ForecastResponse.toDailyForecasts', () {
    Map<String, dynamic> entry(DateTime dt, double temp, double min, double max, String desc, String icon) {
      return {
        'dt': dt.toUtc().millisecondsSinceEpoch ~/ 1000,
        'main': {'temp': temp, 'temp_min': min, 'temp_max': max},
        'weather': [
          {'description': desc, 'icon': icon},
        ],
      };
    }

    test('collapses 3-hourly entries into one entry per calendar day', () {
      // Local (not UTC) reference points, so grouping-by-local-day is
      // deterministic regardless of the host machine's timezone.
      final day1 = DateTime(2026, 1, 1);
      final day2 = DateTime(2026, 1, 2);

      final json = {
        'city': {'name': 'London'},
        'list': [
          entry(day1.add(const Duration(hours: 0)), 10, 8, 11, 'clear sky', '01n'),
          entry(day1.add(const Duration(hours: 12)), 15, 12, 16, 'sunny', '01d'),
          entry(day1.add(const Duration(hours: 21)), 11, 9, 12, 'clear sky', '01n'),
          entry(day2.add(const Duration(hours: 0)), 9, 7, 10, 'clouds', '02n'),
          entry(day2.add(const Duration(hours: 12)), 14, 11, 15, 'cloudy', '02d'),
        ],
      };

      final forecasts = ForecastResponse.fromJson(json).toDailyForecasts();

      expect(forecasts.length, 2);

      expect(forecasts[0].minTemp, 8);
      expect(forecasts[0].maxTemp, 16);
      expect(forecasts[0].description, 'sunny');
      expect(forecasts[0].icon, '01d');

      expect(forecasts[1].minTemp, 7);
      expect(forecasts[1].maxTemp, 15);
      expect(forecasts[1].description, 'cloudy');
      expect(forecasts[1].icon, '02d');
    });

    test('caps the result at the requested number of days', () {
      final entries = List.generate(6, (i) {
        final day = DateTime.utc(2026, 1, 1 + i);
        return entry(day.add(const Duration(hours: 12)), 15, 12, 16, 'sunny', '01d');
      });

      final json = {
        'city': {'name': 'London'},
        'list': entries,
      };

      final forecasts = ForecastResponse.fromJson(json).toDailyForecasts(days: 5);

      expect(forecasts.length, 5);
    });
  });
}
