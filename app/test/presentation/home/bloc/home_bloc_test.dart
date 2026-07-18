import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:core/core.dart';
import 'package:generic_app/presentation/home/bloc/home_bloc.dart';
import 'package:weather/weather.dart';

class MockGetWeatherUseCase extends Mock implements GetWeatherUseCase {}

class MockGetWeatherByLocationUseCase extends Mock implements GetWeatherByLocationUseCase {}

void main() {
  late HomeBloc homeBloc;
  late MockGetWeatherUseCase mockGetWeatherUseCase;
  late MockGetWeatherByLocationUseCase mockGetWeatherByLocationUseCase;

  setUp(() {
    mockGetWeatherUseCase = MockGetWeatherUseCase();
    mockGetWeatherByLocationUseCase = MockGetWeatherByLocationUseCase();
    homeBloc = HomeBloc(mockGetWeatherUseCase, mockGetWeatherByLocationUseCase);
  });

  tearDown(() {
    homeBloc.close();
  });

  final tWeatherData = WeatherData(
    city: 'London',
    temperature: 20.0,
    description: 'Cloudy',
    forecasts: [
      Forecast(
        date: DateTime(2026, 1, 1),
        day: 'Mon',
        minTemp: 16.0,
        maxTemp: 18.0,
        description: 'Rain',
        icon: '10d',
      ),
      Forecast(
        date: DateTime(2026, 1, 2),
        day: 'Tue',
        minTemp: 20.0,
        maxTemp: 22.0,
        description: 'Sunny',
        icon: '01d',
      ),
    ],
  );

  test('initial state should be HomeInitial', () {
    expect(homeBloc.state, HomeInitial());
  });

  blocTest<HomeBloc, HomeState>(
    'emits [HomeLoading, HomeLoaded] when LoadWeather is added successfully',
    build: () {
      when(() => mockGetWeatherUseCase.execute(any()))
          .thenAnswer((_) async => tWeatherData);
      return homeBloc;
    },
    act: (bloc) => bloc.add(const LoadWeather('London')),
    expect: () => [
      HomeLoading(),
      HomeLoaded(tWeatherData),
    ],
    verify: (_) {
      verify(() => mockGetWeatherUseCase.execute('London')).called(1);
    },
  );

  blocTest<HomeBloc, HomeState>(
    'emits [HomeLoading, HomeError] when LoadWeather fails',
    build: () {
      when(() => mockGetWeatherUseCase.execute(any()))
          .thenThrow(Exception('Failed to load weather'));
      return homeBloc;
    },
    act: (bloc) => bloc.add(const LoadWeather('London')),
    expect: () => [
      HomeLoading(),
      const HomeError('Exception: Failed to load weather'),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits [HomeLoading, HomeLoaded] when LoadWeatherForCurrentLocation succeeds',
    build: () {
      when(() => mockGetWeatherByLocationUseCase.execute())
          .thenAnswer((_) async => tWeatherData);
      return homeBloc;
    },
    act: (bloc) => bloc.add(const LoadWeatherForCurrentLocation()),
    expect: () => [
      HomeLoading(),
      HomeLoaded(tWeatherData),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits a permission-denied HomeError when location permission is denied',
    build: () {
      when(() => mockGetWeatherByLocationUseCase.execute())
          .thenThrow(const LocationPermissionDeniedFailure());
      return homeBloc;
    },
    act: (bloc) => bloc.add(const LoadWeatherForCurrentLocation()),
    expect: () => [
      HomeLoading(),
      const HomeError('Location permission was denied', isPermissionDenied: true),
    ],
  );
}
