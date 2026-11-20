import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:generic_app/l10n/app_localizations.dart';
import 'package:weather/weather.dart';

import '../../../injection/injection.dart';
import '../../dashboard/bloc/dashboard_bloc.dart';
import '../../dashboard/bloc/dashboard_event.dart';
import '../bloc/saved_cities_bloc.dart';

class SavedCitiesPage extends StatelessWidget {
  const SavedCitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<SavedCitiesBloc>()..add(const SavedCitiesLoadRequested()),
      child: const _SavedCitiesView(),
    );
  }
}

class _SavedCitiesView extends StatefulWidget {
  const _SavedCitiesView();

  @override
  State<_SavedCitiesView> createState() => _SavedCitiesViewState();
}

class _SavedCitiesViewState extends State<_SavedCitiesView> {
  final _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _search(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(
      const Duration(milliseconds: 350),
      () => context.read<SavedCitiesBloc>().add(SavedCitySearchChanged(query)),
    );
  }

  void _addLocation(WeatherLocation location) {
    _searchDebounce?.cancel();
    _searchController.clear();
    context.read<SavedCitiesBloc>().add(SavedCityAddRequested(location));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onChanged: _search,
            onSubmitted: (query) {
              _searchDebounce?.cancel();
              context.read<SavedCitiesBloc>().add(
                SavedCitySearchChanged(query),
              );
            },
            decoration: InputDecoration(
              hintText: l10n.savedCitiesSearchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _searchController,
                builder: (context, value, _) => value.text.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                        tooltip: MaterialLocalizations.of(
                          context,
                        ).deleteButtonTooltip,
                        onPressed: () {
                          _searchController.clear();
                          context.read<SavedCitiesBloc>().add(
                            const SavedCitySearchChanged(''),
                          );
                        },
                        icon: const Icon(Icons.close),
                      ),
              ),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          BlocBuilder<SavedCitiesBloc, SavedCitiesState>(
            builder: (context, state) {
              if (state.errorMessage == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  state.errorMessage!,
                  style: TextStyle(color: colors.error),
                ),
              );
            },
          ),
          BlocBuilder<SavedCitiesBloc, SavedCitiesState>(
            builder: (context, state) {
              if (state.isSearching) {
                return const LinearProgressIndicator();
              }
              if (state.suggestions.isNotEmpty) {
                return _LocationSuggestions(
                  locations: state.suggestions,
                  isAdding: state.isAdding,
                  onAdd: _addLocation,
                );
              }
              if (state.searchQuery.length >= 2 &&
                  !state.isAdding &&
                  state.errorMessage == null) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    l10n.savedCitiesNoResults,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }
              if (state.isAdding) {
                return const LinearProgressIndicator();
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 8),
          BlocBuilder<SavedCitiesBloc, SavedCitiesState>(
            builder: (context, state) {
              if (state.selectedIds.isEmpty) return const SizedBox.shrink();
              return Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonalIcon(
                  onPressed: state.isRemoving
                      ? null
                      : () => context.read<SavedCitiesBloc>().add(
                          const SavedCitiesRemovalRequested(),
                        ),
                  icon: state.isRemoving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.delete_outline),
                  label: Text(l10n.savedCitiesRemoveSelected),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<SavedCitiesBloc, SavedCitiesState>(
              builder: (context, state) {
                if (state.isLoading && state.cities.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.cities.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_city_outlined,
                            size: 48,
                            color: colors.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.savedCitiesEmptyTitle,
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.savedCitiesEmptyMessage,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: state.cities.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final city = state.cities[index];
                    final selected = state.selectedIds.contains(
                      city.location.id,
                    );
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        onTap: () => context.read<DashboardBloc>().add(
                          DashboardSavedCitySelected(city.location),
                        ),
                        leading: _WeatherIcon(
                          icon: city.cachedWeather?.icon ?? '',
                          color: colors.primary,
                        ),
                        title: Text(city.location.displayName),
                        subtitle: _SavedCityWeatherPreview(city: city),
                        trailing: Checkbox(
                          value: selected,
                          onChanged: (_) => context.read<SavedCitiesBloc>().add(
                            SavedCitySelectionToggled(city.location.id),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationSuggestions extends StatelessWidget {
  final List<WeatherLocation> locations;
  final bool isAdding;
  final ValueChanged<WeatherLocation> onAdd;

  const _LocationSuggestions({
    required this.locations,
    required this.isAdding,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 240),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: locations.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final location = locations[index];
            return ListTile(
              dense: true,
              title: Text(location.name),
              subtitle: Text(
                [
                  if (location.state?.isNotEmpty ?? false) location.state!,
                  location.country,
                ].where((part) => part.isNotEmpty).join(', '),
              ),
              trailing: IconButton(
                tooltip: l10n.savedCitiesAddLocation,
                onPressed: isAdding ? null : () => onAdd(location),
                icon: const Icon(Icons.add_circle_outline),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SavedCityWeatherPreview extends StatelessWidget {
  final SavedCity city;

  const _SavedCityWeatherPreview({required this.city});

  @override
  Widget build(BuildContext context) {
    final weather = city.cachedWeather;
    final cachedAt = city.cachedAt;
    final l10n = AppLocalizations.of(context)!;
    final localeName = Localizations.localeOf(context).toString();

    if (weather == null || cachedAt == null) {
      return Text(l10n.savedCitiesWeatherUnavailable);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${weather.temperature.round()}°C · ${weather.description}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          l10n.savedCitiesUpdatedAt(
            DateFormat.yMMMd(localeName).add_jm().format(cachedAt),
          ),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  final String icon;
  final Color color;

  const _WeatherIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    if (icon.isEmpty) {
      return Icon(Icons.cloud_outlined, color: color);
    }
    return Image.network(
      'https://openweathermap.org/img/wn/$icon@2x.png',
      width: 48,
      height: 48,
      errorBuilder: (context, error, stackTrace) =>
          Icon(Icons.cloud_outlined, color: color),
    );
  }
}
