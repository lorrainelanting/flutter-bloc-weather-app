import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AppConfig {
  String get openWeatherApiKey;
}

class DotEnvAppConfig implements AppConfig {
  @override
  String get openWeatherApiKey => dotenv.env['OPEN_WEATHER_API_KEY'] ?? '';
}
