import 'package:intl/intl.dart';
import '../../domain/models/weather_data.dart';
import '../models/remote/forecast_response.dart';
import '../models/remote/weather_model.dart';

extension WeatherMapper on Weather {
  WeatherData toDomain({List<Forecast> forecasts = const []}) {
    return WeatherData(
      city: city,
      temperature: temperature,
      feelsLike: feelsLike,
      humidity: humidity,
      windSpeed: windSpeed,
      description: description,
      icon: icon,
      forecasts: forecasts,
    );
  }
}

extension ForecastResponseMapper on ForecastResponse {
  /// Collapses the 3-hourly forecast list into one entry per calendar day,
  /// using the min/max temperature across the day and the entry closest to
  /// midday for the representative description/icon.
  List<Forecast> toDailyForecasts({int days = 5}) {
    final byDate = <DateTime, List<ForecastEntry>>{};
    for (final entry in entries) {
      final date = DateTime(entry.dateTime.year, entry.dateTime.month, entry.dateTime.day);
      byDate.putIfAbsent(date, () => []).add(entry);
    }

    final sortedDates = byDate.keys.toList()..sort();

    return sortedDates.take(days).map((date) {
      final dayEntries = byDate[date]!;
      final minTemp = dayEntries.map((e) => e.minTemperature).reduce((a, b) => a < b ? a : b);
      final maxTemp = dayEntries.map((e) => e.maxTemperature).reduce((a, b) => a > b ? a : b);
      final midday = dayEntries.reduce(
        (a, b) => (a.dateTime.hour - 12).abs() <= (b.dateTime.hour - 12).abs() ? a : b,
      );

      return Forecast(
        date: date,
        day: DateFormat.E().format(date),
        minTemp: minTemp,
        maxTemp: maxTemp,
        description: midday.description,
        icon: midday.icon,
      );
    }).toList();
  }
}
