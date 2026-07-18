part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final WeatherData weatherData;

  const HomeLoaded(this.weatherData);

  @override
  List<Object?> get props => [weatherData];
}

class HomeError extends HomeState {
  final String message;
  final bool isPermissionDenied;

  const HomeError(this.message, {this.isPermissionDenied = false});

  @override
  List<Object?> get props => [message, isPermissionDenied];
}
