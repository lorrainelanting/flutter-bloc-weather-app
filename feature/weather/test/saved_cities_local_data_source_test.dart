import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/data/datasources/local/shared_preferences_saved_cities_data_source.dart';
import 'package:weather/domain/models/saved_city.dart';
import 'package:weather/domain/models/weather_data.dart';
import 'package:weather/domain/models/weather_location.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'persists saved locations, cached weather, and update timestamps',
    () async {
      SharedPreferences.setMockInitialValues({});
      final dataSource = SharedPreferencesSavedCitiesDataSource();
      final savedCity = SavedCity(
        location: const WeatherLocation(
          name: 'London',
          country: 'GB',
          latitude: 51.5072,
          longitude: -0.1276,
        ),
        cachedWeather: const WeatherData(
          city: 'London',
          temperature: 18.5,
          feelsLike: 17,
          humidity: 72,
          windSpeed: 4.1,
          description: 'light rain',
          icon: '10d',
        ),
        cachedAt: DateTime(2026, 1, 1, 12, 30),
      );

      await dataSource.saveSavedCities([savedCity]);

      expect(await dataSource.getSavedCities(), [savedCity]);
    },
  );
}
