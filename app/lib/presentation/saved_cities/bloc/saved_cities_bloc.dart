import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/weather.dart';

part 'saved_cities_event.dart';
part 'saved_cities_state.dart';

@injectable
class SavedCitiesBloc extends Bloc<SavedCitiesEvent, SavedCitiesState> {
  final SearchLocationsUseCase _searchLocations;
  final GetSavedCitiesUseCase _getSavedCities;
  final SaveLocationUseCase _saveLocation;
  final RemoveSavedCitiesUseCase _removeSavedCities;
  final GetWeatherForSavedLocationUseCase _getWeatherForSavedLocation;

  SavedCitiesBloc(
    this._searchLocations,
    this._getSavedCities,
    this._saveLocation,
    this._removeSavedCities,
    this._getWeatherForSavedLocation,
  ) : super(const SavedCitiesState()) {
    on<SavedCitiesLoadRequested>(_onLoadRequested);
    on<SavedCitySearchChanged>(_onSearchChanged);
    on<SavedCityAddRequested>(_onAddRequested);
    on<SavedCitySelectionToggled>(_onSelectionToggled);
    on<SavedCitiesRemovalRequested>(_onRemovalRequested);
    on<SavedCitiesErrorDismissed>(
      (_, emit) => emit(state.copyWith(clearError: true)),
    );
  }

  String _errorMessage(Object error) =>
      error is Failure ? error.message : error.toString();

  Future<void> _onLoadRequested(
    SavedCitiesLoadRequested event,
    Emitter<SavedCitiesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final cities = await _getSavedCities.execute();
      emit(state.copyWith(isLoading: false, cities: cities));
    } catch (error) {
      emit(
        state.copyWith(isLoading: false, errorMessage: _errorMessage(error)),
      );
    }
  }

  Future<void> _onSearchChanged(
    SavedCitySearchChanged event,
    Emitter<SavedCitiesState> emit,
  ) async {
    final query = event.query.trim();
    if (query.length < 2) {
      emit(
        state.copyWith(
          searchQuery: query,
          suggestions: const [],
          isSearching: false,
          clearError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        searchQuery: query,
        isSearching: true,
        suggestions: const [],
        clearError: true,
      ),
    );
    try {
      final suggestions = await _searchLocations.execute(query);
      if (state.searchQuery == query) {
        emit(state.copyWith(isSearching: false, suggestions: suggestions));
      }
    } catch (error) {
      if (state.searchQuery == query) {
        emit(
          state.copyWith(isSearching: false, errorMessage: _errorMessage(error)),
        );
      }
    }
  }

  Future<void> _onAddRequested(
    SavedCityAddRequested event,
    Emitter<SavedCitiesState> emit,
  ) async {
    emit(state.copyWith(isAdding: true, clearError: true));
    try {
      await _saveLocation.execute(event.location);
      String? weatherError;
      try {
        await _getWeatherForSavedLocation.execute(event.location);
      } catch (error) {
        weatherError = _errorMessage(error);
      }
      final cities = await _getSavedCities.execute();
      emit(
        state.copyWith(
          isAdding: false,
          cities: cities,
          suggestions: const [],
          searchQuery: '',
          selectedIds: const {},
          errorMessage: weatherError,
          clearError: weatherError == null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(isAdding: false, errorMessage: _errorMessage(error)),
      );
    }
  }

  void _onSelectionToggled(
    SavedCitySelectionToggled event,
    Emitter<SavedCitiesState> emit,
  ) {
    final selectedIds = Set<String>.of(state.selectedIds);
    if (!selectedIds.add(event.locationId)) {
      selectedIds.remove(event.locationId);
    }
    emit(state.copyWith(selectedIds: selectedIds));
  }

  Future<void> _onRemovalRequested(
    SavedCitiesRemovalRequested event,
    Emitter<SavedCitiesState> emit,
  ) async {
    if (state.selectedIds.isEmpty) return;
    emit(state.copyWith(isRemoving: true, clearError: true));
    try {
      await _removeSavedCities.execute(state.selectedIds);
      final cities = await _getSavedCities.execute();
      emit(
        state.copyWith(
          isRemoving: false,
          cities: cities,
          selectedIds: const {},
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(isRemoving: false, errorMessage: _errorMessage(error)),
      );
    }
  }
}
