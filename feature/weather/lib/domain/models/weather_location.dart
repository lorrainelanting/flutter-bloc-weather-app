import 'package:core/core.dart';

class WeatherLocation extends Equatable {
  final String name;
  final String country;
  final String? state;
  final double latitude;
  final double longitude;

  const WeatherLocation({
    required this.name,
    required this.country,
    this.state,
    required this.latitude,
    required this.longitude,
  });

  String get id =>
      '${latitude.toStringAsFixed(6)},${longitude.toStringAsFixed(6)}';

  String get displayName => [
    name,
    if (state != null && state!.isNotEmpty) state!,
    if (country.isNotEmpty) country,
  ].join(', ');

  @override
  List<Object?> get props => [name, country, state, latitude, longitude];
}
