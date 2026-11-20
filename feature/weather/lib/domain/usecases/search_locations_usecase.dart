import 'package:core/core.dart';
import '../models/weather_location.dart';
import '../repositories/weather_repository.dart';

@injectable
class SearchLocationsUseCase {
  final WeatherRepository _repository;

  SearchLocationsUseCase(this._repository);

  Future<List<WeatherLocation>> execute(String query) {
    return _repository.searchLocations(query);
  }
}
