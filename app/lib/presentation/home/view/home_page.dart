import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_app/l10n/app_localizations.dart';
import 'package:weather/weather.dart';
import '../../../injection/injection.dart';
import '../bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<HomeBloc>()..add(const LoadWeatherForCurrentLocation()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading || state is HomeInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HomeError) {
          return _HomeErrorView(
            message: state.isPermissionDenied ? l10n.locationPermissionDenied : state.message,
            onRetry: () => context
                .read<HomeBloc>()
                .add(const LoadWeatherForCurrentLocation()),
          );
        }

        if (state is HomeLoaded) {
          final weather = state.weatherData;
          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(const LoadWeatherForCurrentLocation());
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _CurrentWeatherCard(weather: weather, l10n: l10n),
                const SizedBox(height: 24),
                Text(l10n.forecastTitle, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: weather.forecasts.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final forecast = weather.forecasts[index];
                    return ListTile(
                      leading: _WeatherIcon(icon: forecast.icon),
                      title: Text(forecast.day),
                      subtitle: Text(forecast.description),
                      trailing: Text(
                        '${forecast.maxTemp.round()}° / ${forecast.minTemp.round()}°',
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _CurrentWeatherCard extends StatelessWidget {
  final WeatherData weather;
  final AppLocalizations l10n;

  const _CurrentWeatherCard({required this.weather, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(weather.city, style: Theme.of(context).textTheme.headlineMedium),
          _WeatherIcon(icon: weather.icon, size: 72),
          Text('${weather.temperature.round()}°C', style: Theme.of(context).textTheme.displayMedium),
          Text(weather.description),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            alignment: WrapAlignment.center,
            children: [
              Text(l10n.weatherFeelsLike(weather.feelsLike.round().toString())),
              Text(l10n.weatherHumidity(weather.humidity.toString())),
              Text(l10n.weatherWind(weather.windSpeed.toStringAsFixed(1))),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  final String icon;
  final double size;

  const _WeatherIcon({required this.icon, this.size = 40});

  @override
  Widget build(BuildContext context) {
    if (icon.isEmpty) {
      return SizedBox(width: size, height: size);
    }
    return Image.network(
      'https://openweathermap.org/img/wn/$icon@2x.png',
      width: size,
      height: size,
      errorBuilder: (context, error, stackTrace) => SizedBox(width: size, height: size),
    );
  }
}

class _HomeErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _HomeErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: Text(l10n.weatherRetry)),
          ],
        ),
      ),
    );
  }
}
