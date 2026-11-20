part of 'saved_cities_bloc.dart';

class SavedCitiesState extends Equatable {
  final List<SavedCity> cities;
  final List<WeatherLocation> suggestions;
  final Set<String> selectedIds;
  final String searchQuery;
  final String? errorMessage;
  final bool isLoading;
  final bool isSearching;
  final bool isAdding;
  final bool isRemoving;

  const SavedCitiesState({
    this.cities = const [],
    this.suggestions = const [],
    this.selectedIds = const {},
    this.searchQuery = '',
    this.errorMessage,
    this.isLoading = false,
    this.isSearching = false,
    this.isAdding = false,
    this.isRemoving = false,
  });

  SavedCitiesState copyWith({
    List<SavedCity>? cities,
    List<WeatherLocation>? suggestions,
    Set<String>? selectedIds,
    String? searchQuery,
    String? errorMessage,
    bool clearError = false,
    bool? isLoading,
    bool? isSearching,
    bool? isAdding,
    bool? isRemoving,
  }) {
    return SavedCitiesState(
      cities: cities ?? this.cities,
      suggestions: suggestions ?? this.suggestions,
      selectedIds: selectedIds ?? this.selectedIds,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      isAdding: isAdding ?? this.isAdding,
      isRemoving: isRemoving ?? this.isRemoving,
    );
  }

  @override
  List<Object?> get props => [
    cities,
    suggestions,
    selectedIds,
    searchQuery,
    errorMessage,
    isLoading,
    isSearching,
    isAdding,
    isRemoving,
  ];
}
