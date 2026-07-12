import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardState()) {
    on<DashboardTabChanged>(_onTabChanged);
  }

  void _onTabChanged(DashboardTabChanged event, Emitter<DashboardState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
  }
}
