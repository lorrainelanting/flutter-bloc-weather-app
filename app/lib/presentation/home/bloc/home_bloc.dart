import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:weather/domain/models/weather_data.dart';
import 'package:weather/domain/usecases/get_weather_usecase.dart';
import 'package:weather/domain/usecases/get_weather_by_location_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetWeatherUseCase _getWeatherUseCase;
  final GetWeatherByLocationUseCase _getWeatherByLocationUseCase;

  HomeBloc(
    this._getWeatherUseCase,
    this._getWeatherByLocationUseCase,
  ) : super(HomeInitial()) {
    on<LoadWeather>(_onLoadWeather);
    on<LoadWeatherForCurrentLocation>(_onLoadWeatherForCurrentLocation);
  }

  Future<void> _onLoadWeather(LoadWeather event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final weather = await _getWeatherUseCase.execute(event.city);
      emit(HomeLoaded(weather));
    } on Failure catch (e) {
      emit(HomeError(e.message));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onLoadWeatherForCurrentLocation(
    LoadWeatherForCurrentLocation event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final weather = await _getWeatherByLocationUseCase.execute();
      emit(HomeLoaded(weather));
    } on LocationPermissionDeniedFailure catch (e) {
      emit(HomeError(e.message, isPermissionDenied: true));
    } on LocationServiceDisabledFailure catch (e) {
      emit(HomeError(e.message, isPermissionDenied: true));
    } on Failure catch (e) {
      emit(HomeError(e.message));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
