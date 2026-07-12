// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Login';

  @override
  String get loginButton => 'Login';

  @override
  String get loginWithGoogle => 'Login with Google';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Register';

  @override
  String get registerTitle => 'Register';

  @override
  String get registerButton => 'Register';

  @override
  String get registerWithGoogle => 'Register with Google';

  @override
  String get dashboardWeatherTitle => 'Weather';

  @override
  String get dashboardSavedCitiesTitle => 'Saved Cities';

  @override
  String get dashboardSettingsTitle => 'Settings';

  @override
  String get tabHome => 'Home';

  @override
  String get tabSaved => 'Saved';

  @override
  String get tabSettings => 'Settings';

  @override
  String get homeScreenPlaceholder => 'Home Screen - Weather Forecast';

  @override
  String get savedCitiesPlaceholder => 'Saved Cities Screen';

  @override
  String get settingsPlaceholder => 'Settings Screen';
}
