import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:core/core.dart';
import 'package:generic_app/presentation/home/bloc/home_bloc.dart';
import 'package:weather/weather.dart';

class MockGetWeatherUseCase extends Mock implements GetWeatherUseCase {}

class MockGetWeatherByLocationUseCase extends Mock
    implements GetWeatherByLocationUseCase {}

class MockGetWeatherForSavedLocationUseCase extends Mock
    implements GetWeatherForSavedLocationUseCase {}

void main() {
  late HomeBloc homeBloc;
  late MockGetWeatherUseCase mockGetWeatherUseCase;
  late MockGetWeatherByLocationUseCase mockGetWeatherByLocationUseCase;
  late MockGetWeatherForSavedLocationUseCase
  mockGetWeatherForSavedLocationUseCase;

  setUp(() {
    mockGetWeatherUseCase = MockGetWeatherUseCase();
    mockGetWeatherByLocationUseCase = MockGetWeatherByLocationUseCase();
    mockGetWeatherForSavedLocationUseCase =
        MockGetWeatherForSavedLocationUseCase();
    homeBloc = HomeBloc(
      mockGetWeatherUseCase,
      mockGetWeatherByLocationUseCase,
      mockGetWeatherForSavedLocationUseCase,
    );
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
  const tSavedLocation = WeatherLocation(
    name: 'London',
    country: 'GB',
    latitude: 51.5072,
    longitude: -0.1276,
  );

  test('initial state should be HomeInitial', () {
    expect(homeBloc.state, HomeInitial());
  });

  blocTest<HomeBloc, HomeState>(
    'emits [HomeLoading, HomeLoaded] when LoadWeather is added successfully',
    build: () {
      when(
        () => mockGetWeatherUseCase.execute(any()),
      ).thenAnswer((_) async => tWeatherData);
      return homeBloc;
    },
    act: (bloc) => bloc.add(const LoadWeather('London')),
    expect: () => [HomeLoading(), HomeLoaded(tWeatherData)],
    verify: (_) {
      verify(() => mockGetWeatherUseCase.execute('London')).called(1);
    },
  );

  blocTest<HomeBloc, HomeState>(
    'loads and caches fresh weather for a selected saved location',
    build: () {
      when(
        () => mockGetWeatherForSavedLocationUseCase.execute(tSavedLocation),
      ).thenAnswer((_) async => tWeatherData);
      return homeBloc;
    },
    act: (bloc) => bloc.add(const LoadWeatherForSavedLocation(tSavedLocation)),
    expect: () => [HomeLoading(), HomeLoaded(tWeatherData)],
  );

  blocTest<HomeBloc, HomeState>(
    'emits [HomeLoading, HomeError] when LoadWeather fails',
    build: () {
      when(
        () => mockGetWeatherUseCase.execute(any()),
      ).thenThrow(Exception('Failed to load weather'));
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
      when(
        () => mockGetWeatherByLocationUseCase.execute(),
      ).thenAnswer((_) async => tWeatherData);
      return homeBloc;
    },
    act: (bloc) => bloc.add(const LoadWeatherForCurrentLocation()),
    expect: () => [HomeLoading(), HomeLoaded(tWeatherData)],
  );

  blocTest<HomeBloc, HomeState>(
    'emits a permission-denied HomeError when location permission is denied',
    build: () {
      when(
        () => mockGetWeatherByLocationUseCase.execute(),
      ).thenThrow(const LocationPermissionDeniedFailure());
      return homeBloc;
    },
    act: (bloc) => bloc.add(const LoadWeatherForCurrentLocation()),
    expect: () => [
      HomeLoading(),
      const HomeError(
        'Location permission was denied',
        isPermissionDenied: true,
      ),
    ],
  );
}
