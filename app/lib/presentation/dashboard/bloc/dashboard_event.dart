import 'package:equatable/equatable.dart';
import 'package:weather/weather.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class DashboardTabChanged extends DashboardEvent {
  final int index;

  const DashboardTabChanged(this.index);

  @override
  List<Object> get props => [index];
}

class DashboardSavedCitySelected extends DashboardEvent {
  final WeatherLocation location;

  const DashboardSavedCitySelected(this.location);

  @override
  List<Object> get props => [location];
}
