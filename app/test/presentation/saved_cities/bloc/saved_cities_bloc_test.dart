import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:generic_app/presentation/saved_cities/bloc/saved_cities_bloc.dart';
import 'package:weather/weather.dart';

class MockSearchLocationsUseCase extends Mock
    implements SearchLocationsUseCase {}

class MockGetSavedCitiesUseCase extends Mock implements GetSavedCitiesUseCase {}

class MockSaveLocationUseCase extends Mock implements SaveLocationUseCase {}

class MockRemoveSavedCitiesUseCase extends Mock
    implements RemoveSavedCitiesUseCase {}

class MockGetWeatherForSavedLocationUseCase extends Mock
    implements GetWeatherForSavedLocationUseCase {}

void main() {
  late MockSearchLocationsUseCase searchLocations;
  late MockGetSavedCitiesUseCase getSavedCities;
  late MockSaveLocationUseCase saveLocation;
  late MockRemoveSavedCitiesUseCase removeSavedCities;
  late MockGetWeatherForSavedLocationUseCase getWeatherForSavedLocation;

  const london = WeatherLocation(
    name: 'London',
    country: 'GB',
    latitude: 51.5072,
    longitude: -0.1276,
  );
  const weather = WeatherData(
    city: 'London',
    temperature: 18,
    description: 'Cloudy',
  );
  final savedLondon = SavedCity(
    location: london,
    cachedWeather: weather,
    cachedAt: DateTime(2026, 1, 1, 12),
  );

  setUp(() {
    searchLocations = MockSearchLocationsUseCase();
    getSavedCities = MockGetSavedCitiesUseCase();
    saveLocation = MockSaveLocationUseCase();
    removeSavedCities = MockRemoveSavedCitiesUseCase();
    getWeatherForSavedLocation = MockGetWeatherForSavedLocationUseCase();
  });

  SavedCitiesBloc createBloc() => SavedCitiesBloc(
    searchLocations,
    getSavedCities,
    saveLocation,
    removeSavedCities,
    getWeatherForSavedLocation,
  );

  blocTest<SavedCitiesBloc, SavedCitiesState>(
    'shows location suggestions for a search query',
    build: () {
      when(
        () => searchLocations.execute('London'),
      ).thenAnswer((_) async => [london]);
      return createBloc();
    },
    act: (bloc) => bloc.add(const SavedCitySearchChanged('London')),
    expect: () => [
      const SavedCitiesState(searchQuery: 'London', isSearching: true),
      const SavedCitiesState(searchQuery: 'London', suggestions: [london]),
    ],
  );

  blocTest<SavedCitiesBloc, SavedCitiesState>(
    'removes selected saved cities and clears the selection',
    build: () {
      when(
        () => removeSavedCities.execute({london.id}),
      ).thenAnswer((_) async {});
      when(() => getSavedCities.execute()).thenAnswer((_) async => []);
      return createBloc();
    },
    seed: () =>
        SavedCitiesState(cities: [savedLondon], selectedIds: {london.id}),
    act: (bloc) => bloc.add(const SavedCitiesRemovalRequested()),
    expect: () => [
      SavedCitiesState(
        cities: [savedLondon],
        selectedIds: {london.id},
        isRemoving: true,
      ),
      const SavedCitiesState(),
    ],
    verify: (_) {
      verify(() => removeSavedCities.execute({london.id})).called(1);
    },
  );
}
