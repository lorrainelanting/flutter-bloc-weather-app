part of 'saved_cities_bloc.dart';

abstract class SavedCitiesEvent extends Equatable {
  const SavedCitiesEvent();

  @override
  List<Object> get props => [];
}

class SavedCitiesLoadRequested extends SavedCitiesEvent {
  const SavedCitiesLoadRequested();
}

class SavedCitySearchChanged extends SavedCitiesEvent {
  final String query;

  const SavedCitySearchChanged(this.query);

  @override
  List<Object> get props => [query];
}

class SavedCityAddRequested extends SavedCitiesEvent {
  final WeatherLocation location;

  const SavedCityAddRequested(this.location);

  @override
  List<Object> get props => [location];
}

class SavedCitySelectionToggled extends SavedCitiesEvent {
  final String locationId;

  const SavedCitySelectionToggled(this.locationId);

  @override
  List<Object> get props => [locationId];
}

class SavedCitiesRemovalRequested extends SavedCitiesEvent {
  const SavedCitiesRemovalRequested();
}

class SavedCitiesErrorDismissed extends SavedCitiesEvent {
  const SavedCitiesErrorDismissed();
}
