import 'package:core/core.dart';
import 'weather_data.dart';
import 'weather_location.dart';

class SavedCity extends Equatable {
  final WeatherLocation location;
  final WeatherData? cachedWeather;
  final DateTime? cachedAt;

  const SavedCity({required this.location, this.cachedWeather, this.cachedAt});

  SavedCity copyWith({WeatherData? cachedWeather, DateTime? cachedAt}) {
    return SavedCity(
      location: location,
      cachedWeather: cachedWeather ?? this.cachedWeather,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  List<Object?> get props => [location, cachedWeather, cachedAt];
}
