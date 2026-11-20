import 'package:core/core.dart';
import '../repositories/weather_repository.dart';

@injectable
class RemoveSavedCitiesUseCase {
  final WeatherRepository _repository;

  RemoveSavedCitiesUseCase(this._repository);

  Future<void> execute(Set<String> locationIds) {
    return _repository.removeSavedCities(locationIds);
  }
}
