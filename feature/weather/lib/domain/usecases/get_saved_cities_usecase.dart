import 'package:core/core.dart';
import '../models/saved_city.dart';
import '../repositories/weather_repository.dart';

@injectable
class GetSavedCitiesUseCase {
  final WeatherRepository _repository;

  GetSavedCitiesUseCase(this._repository);

  Future<List<SavedCity>> execute() => _repository.getSavedCities();
}
