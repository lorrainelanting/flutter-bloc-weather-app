import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AppConfig {
  String get openWeatherApiKey;
  String get openWeatherBaseUrl;
}

class DotEnvAppConfig implements AppConfig {
  static const _defaultOpenWeatherBaseUrl = 'https://api.openweathermap.org';

  @override
  String get openWeatherApiKey => dotenv.env['OPEN_WEATHER_API_KEY'] ?? '';

  @override
  String get openWeatherBaseUrl {
    final configuredUrl = dotenv.env['OPEN_WEATHER_BASE_URL'];
    if (configuredUrl == null) return _defaultOpenWeatherBaseUrl;

    final uri = Uri.tryParse(configuredUrl.trim());
    if (uri == null ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      throw const FormatException(
        'OPEN_WEATHER_BASE_URL must be an absolute HTTP(S) URL.',
      );
    }

    return uri.origin;
  }
}
