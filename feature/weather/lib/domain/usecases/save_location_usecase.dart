import 'package:core/core.dart';
import '../models/weather_location.dart';
import '../repositories/weather_repository.dart';

@injectable
class SaveLocationUseCase {
  final WeatherRepository _repository;

  SaveLocationUseCase(this._repository);

  Future<void> execute(WeatherLocation location) {
    return _repository.saveLocation(location);
  }
}
