import 'package:core/core.dart';
import '../models/weather_data.dart';
import '../repositories/weather_repository.dart';

@injectable
class GetWeatherByLocationUseCase {
  final WeatherRepository _weatherRepository;
  final LocationService _locationService;

  GetWeatherByLocationUseCase({
    required WeatherRepository weatherRepository,
    required LocationService locationService,
  })  : _weatherRepository = weatherRepository,
        _locationService = locationService;

  Future<WeatherData> execute() async {
    final coordinates = await _locationService.getCurrentPosition();
    return _weatherRepository.getWeatherByCoords(coordinates.latitude, coordinates.longitude);
  }
}
