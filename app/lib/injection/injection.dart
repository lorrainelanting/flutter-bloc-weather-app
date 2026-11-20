import 'package:get_it/get_it.dart';
import 'package:core/core.dart';
import 'package:weather/weather.dart';
import 'package:auth/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

@module
abstract class RegisterModule {
  @lazySingleton
  BaseApiClient getBaseApiClient(AppConfig appConfig) =>
      BaseApiClient(baseUrl: appConfig.openWeatherBaseUrl);

  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn();

  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  AppConfig get appConfig => DotEnvAppConfig();

  @lazySingleton
  LocationService get locationService => GeolocatorLocationService();

  @lazySingleton
  AuthLocalDataSource get authLocalDataSource => AuthLocalDataSourceImpl();

  @lazySingleton
  AuthRemoteDataSource getAuthRemoteDataSource(
    GoogleSignIn googleSignIn,
    FirebaseAuth firebaseAuth,
  ) => AuthRemoteDataSourceImpl(googleSignIn, firebaseAuth);

  @lazySingleton
  AuthRepository getAuthRepository(
    AuthLocalDataSource localDataSource,
    AuthRemoteDataSource remoteDataSource,
  ) => AuthRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );

  @injectable
  LoginWithEmailUseCase getLoginWithEmailUseCase(AuthRepository repository) =>
      LoginWithEmailUseCase(repository);

  @injectable
  LoginWithGoogleUseCase getLoginWithGoogleUseCase(AuthRepository repository) =>
      LoginWithGoogleUseCase(repository);

  @injectable
  RegisterWithEmailUseCase getRegisterWithEmailUseCase(
    AuthRepository repository,
  ) => RegisterWithEmailUseCase(repository);

  @injectable
  RegisterWithGoogleUseCase getRegisterWithGoogleUseCase(
    AuthRepository repository,
  ) => RegisterWithGoogleUseCase(repository);

  @injectable
  SignOutUseCase getSignOutUseCase(AuthRepository repository) =>
      SignOutUseCase(repository);

  @injectable
  OpenWeatherApiService getOpenWeatherApiService(BaseApiClient client) =>
      OpenWeatherApiService(client);

  @lazySingleton
  SavedCitiesLocalDataSource get savedCitiesLocalDataSource =>
      SharedPreferencesSavedCitiesDataSource();

  @lazySingleton
  WeatherRepository getWeatherRepository(
    OpenWeatherApiService apiService,
    AppConfig appConfig,
    SavedCitiesLocalDataSource localDataSource,
  ) => WeatherRepositoryImpl(apiService, appConfig, localDataSource);

  @injectable
  GetWeatherUseCase getGetWeatherUseCase(WeatherRepository repository) =>
      GetWeatherUseCase(repository);

  @injectable
  GetWeatherByLocationUseCase getGetWeatherByLocationUseCase(
    WeatherRepository weatherRepository,
    LocationService locationService,
  ) => GetWeatherByLocationUseCase(
    weatherRepository: weatherRepository,
    locationService: locationService,
  );

  @injectable
  SearchLocationsUseCase getSearchLocationsUseCase(
    WeatherRepository repository,
  ) => SearchLocationsUseCase(repository);

  @injectable
  GetSavedCitiesUseCase getGetSavedCitiesUseCase(
    WeatherRepository repository,
  ) => GetSavedCitiesUseCase(repository);

  @injectable
  SaveLocationUseCase getSaveLocationUseCase(WeatherRepository repository) =>
      SaveLocationUseCase(repository);

  @injectable
  RemoveSavedCitiesUseCase getRemoveSavedCitiesUseCase(
    WeatherRepository repository,
  ) => RemoveSavedCitiesUseCase(repository);

  @injectable
  GetWeatherForSavedLocationUseCase getGetWeatherForSavedLocationUseCase(
    WeatherRepository repository,
  ) => GetWeatherForSavedLocationUseCase(repository);
}
