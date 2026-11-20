import '../../../domain/models/saved_city.dart';

abstract class SavedCitiesLocalDataSource {
  Future<List<SavedCity>> getSavedCities();

  Future<void> saveSavedCities(List<SavedCity> cities);
}
