import 'dart:convert';

import 'package:core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/models/saved_city.dart';
import '../../../domain/models/weather_data.dart';
import '../../../domain/models/weather_location.dart';
import 'saved_cities_local_data_source.dart';

class SharedPreferencesSavedCitiesDataSource
    implements SavedCitiesLocalDataSource {
  static const _storageKey = 'saved_weather_cities';

  Future<SharedPreferences> get _preferences => SharedPreferences.getInstance();

  @override
  Future<List<SavedCity>> getSavedCities() async {
    final value = (await _preferences).getString(_storageKey);
    if (value == null || value.isEmpty) return [];

    try {
      final decoded = jsonDecode(value);
      if (decoded is! List) {
        throw const FormatException('Saved cities data is not a list');
      }
      return decoded.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Saved city data is invalid');
        }
        return _savedCityFromJson(item);
      }).toList();
    } on FormatException catch (error) {
      throw CacheFailure('INVALID_SAVED_CITIES', error.message);
    } on TypeError catch (error) {
      throw CacheFailure('INVALID_SAVED_CITIES', error.toString());
    }
  }

  @override
  Future<void> saveSavedCities(List<SavedCity> cities) async {
    final json = jsonEncode(cities.map(_savedCityToJson).toList());
    final saved = await (await _preferences).setString(_storageKey, json);
    if (!saved) {
      throw const CacheFailure(
        'SAVED_CITIES_WRITE_FAILED',
        'Could not save your saved cities',
      );
    }
  }

  Map<String, dynamic> _savedCityToJson(SavedCity city) => {
    'location': {
      'name': city.location.name,
      'country': city.location.country,
      'state': city.location.state,
      'latitude': city.location.latitude,
      'longitude': city.location.longitude,
    },
    'cachedAt': city.cachedAt?.toIso8601String(),
    'weather': city.cachedWeather == null
        ? null
        : _weatherToJson(city.cachedWeather!),
  };

  SavedCity _savedCityFromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>;
    final weatherJson = json['weather'] as Map<String, dynamic>?;
    final cachedAt = json['cachedAt'] as String?;
    return SavedCity(
      location: WeatherLocation(
        name: location['name'] as String,
        country: location['country'] as String? ?? '',
        state: location['state'] as String?,
        latitude: (location['latitude'] as num).toDouble(),
        longitude: (location['longitude'] as num).toDouble(),
      ),
      cachedWeather: weatherJson == null ? null : _weatherFromJson(weatherJson),
      cachedAt: cachedAt == null ? null : DateTime.parse(cachedAt),
    );
  }

  Map<String, dynamic> _weatherToJson(WeatherData weather) => {
    'city': weather.city,
    'temperature': weather.temperature,
    'feelsLike': weather.feelsLike,
    'humidity': weather.humidity,
    'windSpeed': weather.windSpeed,
    'description': weather.description,
    'icon': weather.icon,
    'forecasts': weather.forecasts
        .map(
          (forecast) => {
            'date': forecast.date.toIso8601String(),
            'day': forecast.day,
            'minTemp': forecast.minTemp,
            'maxTemp': forecast.maxTemp,
            'description': forecast.description,
            'icon': forecast.icon,
          },
        )
        .toList(),
  };

  WeatherData _weatherFromJson(Map<String, dynamic> json) => WeatherData(
    city: json['city'] as String,
    temperature: (json['temperature'] as num).toDouble(),
    feelsLike: (json['feelsLike'] as num).toDouble(),
    humidity: (json['humidity'] as num).toInt(),
    windSpeed: (json['windSpeed'] as num).toDouble(),
    description: json['description'] as String,
    icon: json['icon'] as String,
    forecasts: (json['forecasts'] as List<dynamic>? ?? []).map((item) {
      final forecast = item as Map<String, dynamic>;
      return Forecast(
        date: DateTime.parse(forecast['date'] as String),
        day: forecast['day'] as String,
        minTemp: (forecast['minTemp'] as num).toDouble(),
        maxTemp: (forecast['maxTemp'] as num).toDouble(),
        description: forecast['description'] as String,
        icon: forecast['icon'] as String,
      );
    }).toList(),
  );
}
