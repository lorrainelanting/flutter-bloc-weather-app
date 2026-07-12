import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_app/l10n/app_localizations.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../../home/view/home_page.dart';
import '../../saved_cities/view/saved_cities_page.dart';
import '../../settings/view/settings_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SavedCitiesPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final titles = <String>[
      l10n.dashboardWeatherTitle,
      l10n.dashboardSavedCitiesTitle,
      l10n.dashboardSettingsTitle,
    ];

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(titles[state.selectedIndex]),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: IndexedStack(
            index: state.selectedIndex,
            children: _widgetOptions,
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.wb_sunny_outlined),
                activeIcon: const Icon(Icons.wb_sunny),
                label: l10n.tabHome,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.location_city_outlined),
                activeIcon: const Icon(Icons.location_city),
                label: l10n.tabSaved,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings_outlined),
                activeIcon: const Icon(Icons.settings),
                label: l10n.tabSettings,
              ),
            ],
            currentIndex: state.selectedIndex,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            onTap: (index) =>
                context.read<DashboardBloc>().add(DashboardTabChanged(index)),
          ),
        );
      },
    );
  }
}
