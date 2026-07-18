part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadWeatherForCurrentLocation extends HomeEvent {
  const LoadWeatherForCurrentLocation();
}

class LoadWeather extends HomeEvent {
  final String city;
  const LoadWeather(this.city);

  @override
  List<Object> get props => [city];
}
