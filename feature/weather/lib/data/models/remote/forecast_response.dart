class ForecastEntry {
  final DateTime dateTime;
  final double temperature;
  final double minTemperature;
  final double maxTemperature;
  final String description;
  final String icon;

  const ForecastEntry({
    required this.dateTime,
    required this.temperature,
    required this.minTemperature,
    required this.maxTemperature,
    required this.description,
    required this.icon,
  });

  factory ForecastEntry.fromJson(Map<String, dynamic> json) {
    final condition = (json['weather'] as List).first as Map<String, dynamic>;
    final main = json['main'] as Map<String, dynamic>;

    return ForecastEntry(
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] as num).toInt() * 1000, isUtc: true).toLocal(),
      temperature: (main['temp'] as num).toDouble(),
      minTemperature: (main['temp_min'] as num).toDouble(),
      maxTemperature: (main['temp_max'] as num).toDouble(),
      description: condition['description'] as String? ?? '',
      icon: condition['icon'] as String? ?? '',
    );
  }
}

class ForecastResponse {
  final String city;
  final List<ForecastEntry> entries;

  const ForecastResponse({required this.city, required this.entries});

  factory ForecastResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['list'] as List)
        .map((e) => ForecastEntry.fromJson(e as Map<String, dynamic>))
        .toList();
    final cityJson = json['city'] as Map<String, dynamic>?;

    return ForecastResponse(
      city: cityJson?['name'] as String? ?? '',
      entries: list,
    );
  }
}
