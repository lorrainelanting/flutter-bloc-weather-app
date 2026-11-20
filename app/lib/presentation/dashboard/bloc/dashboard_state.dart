import 'package:equatable/equatable.dart';
import 'package:weather/weather.dart';

class DashboardState extends Equatable {
  final int selectedIndex;
  final WeatherLocation? selectedLocation;
  final int selectionVersion;

  const DashboardState({
    this.selectedIndex = 0,
    this.selectedLocation,
    this.selectionVersion = 0,
  });

  DashboardState copyWith({
    int? selectedIndex,
    WeatherLocation? selectedLocation,
    int? selectionVersion,
  }) {
    return DashboardState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectionVersion: selectionVersion ?? this.selectionVersion,
    );
  }

  @override
  List<Object?> get props => [
    selectedIndex,
    selectedLocation,
    selectionVersion,
  ];
}
