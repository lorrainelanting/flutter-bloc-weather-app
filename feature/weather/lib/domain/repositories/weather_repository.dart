import '../models/saved_city.dart';
import '../models/weather_data.dart';
import '../models/weather_location.dart';

abstract class WeatherRepository {
  Future<WeatherData> getWeather(String cityName);

  Future<WeatherData> getWeatherByCoords(double lat, double lon);

  Future<List<WeatherLocation>> searchLocations(String query);

  Future<List<SavedCity>> getSavedCities();

  Future<void> saveLocation(WeatherLocation location);

  Future<void> removeSavedCities(Set<String> locationIds);

  Future<void> cacheWeather(
    WeatherLocation location,
    WeatherData weather,
    DateTime cachedAt,
  );
}
