// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auth/auth.dart' as _i662;
import 'package:core/core.dart' as _i494;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:generic_app/injection/injection.dart' as _i461;
import 'package:generic_app/navigation/navigation_service_impl.dart' as _i1067;
import 'package:generic_app/presentation/auth/login/bloc/login_bloc.dart'
    as _i424;
import 'package:generic_app/presentation/auth/register/bloc/register_bloc.dart'
    as _i806;
import 'package:generic_app/presentation/home/bloc/home_bloc.dart' as _i55;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:weather/domain/usecases/get_weather_by_location_usecase.dart'
    as _i584;
import 'package:weather/domain/usecases/get_weather_usecase.dart' as _i9;
import 'package:weather/weather.dart' as _i217;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i494.BaseApiClient>(() => registerModule.baseApiClient);
    gh.lazySingleton<_i116.GoogleSignIn>(() => registerModule.googleSignIn);
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i494.AppConfig>(() => registerModule.appConfig);
    gh.lazySingleton<_i494.LocationService>(
      () => registerModule.locationService,
    );
    gh.lazySingleton<_i662.AuthLocalDataSource>(
      () => registerModule.authLocalDataSource,
    );
    gh.lazySingleton<_i494.NavigationService>(
      () => _i1067.NavigationServiceImpl(),
    );
    gh.factory<_i217.OpenWeatherApiService>(
      () => registerModule.getOpenWeatherApiService(gh<_i494.BaseApiClient>()),
    );
    gh.lazySingleton<_i662.AuthRemoteDataSource>(
      () => registerModule.getAuthRemoteDataSource(
        gh<_i116.GoogleSignIn>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i662.AuthRepository>(
      () => registerModule.getAuthRepository(
        gh<_i662.AuthLocalDataSource>(),
        gh<_i662.AuthRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i217.WeatherRepository>(
      () => registerModule.getWeatherRepository(
        gh<_i217.OpenWeatherApiService>(),
        gh<_i494.AppConfig>(),
      ),
    );
    gh.factory<_i217.GetWeatherUseCase>(
      () => registerModule.getGetWeatherUseCase(gh<_i217.WeatherRepository>()),
    );
    gh.factory<_i662.LoginWithEmailUseCase>(
      () => registerModule.getLoginWithEmailUseCase(gh<_i662.AuthRepository>()),
    );
    gh.factory<_i662.LoginWithGoogleUseCase>(
      () =>
          registerModule.getLoginWithGoogleUseCase(gh<_i662.AuthRepository>()),
    );
    gh.factory<_i662.RegisterWithEmailUseCase>(
      () => registerModule.getRegisterWithEmailUseCase(
        gh<_i662.AuthRepository>(),
      ),
    );
    gh.factory<_i662.RegisterWithGoogleUseCase>(
      () => registerModule.getRegisterWithGoogleUseCase(
        gh<_i662.AuthRepository>(),
      ),
    );
    gh.factory<_i662.SignOutUseCase>(
      () => registerModule.getSignOutUseCase(gh<_i662.AuthRepository>()),
    );
    gh.factory<_i424.LoginBloc>(
      () => _i424.LoginBloc(
        loginWithEmailUseCase: gh<_i662.LoginWithEmailUseCase>(),
        loginWithGoogleUseCase: gh<_i662.LoginWithGoogleUseCase>(),
      ),
    );
    gh.factory<_i217.GetWeatherByLocationUseCase>(
      () => registerModule.getGetWeatherByLocationUseCase(
        gh<_i217.WeatherRepository>(),
        gh<_i494.LocationService>(),
      ),
    );
    gh.factory<_i806.RegisterBloc>(
      () => _i806.RegisterBloc(
        registerWithEmailUseCase: gh<_i662.RegisterWithEmailUseCase>(),
        registerWithGoogleUseCase: gh<_i662.RegisterWithGoogleUseCase>(),
      ),
    );
    gh.factory<_i55.HomeBloc>(
      () => _i55.HomeBloc(
        gh<_i9.GetWeatherUseCase>(),
        gh<_i584.GetWeatherByLocationUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i461.RegisterModule {}
