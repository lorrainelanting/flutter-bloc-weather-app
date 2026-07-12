import 'package:equatable/equatable.dart';

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
