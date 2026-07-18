import '../models/weather_data.dart';

abstract class WeatherRepository {
  Future<WeatherData> getWeather(String cityName);

  Future<WeatherData> getWeatherByCoords(double lat, double lon);
}
