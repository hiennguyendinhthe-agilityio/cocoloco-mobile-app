// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get searchCityHint => 'Ready to check the weather?';

  @override
  String get feelsLike => 'Feels like';

  @override
  String get humidity => 'Humidity';

  @override
  String get wind => 'Wind';

  @override
  String get low => 'Low';

  @override
  String get high => 'High';

  @override
  String get noWeatherSearchPrompt =>
      'No weather data. Search for a city to get started.';

  @override
  String get tryAnotherSearch => 'Try another search.';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Dark Theme';

  @override
  String get unknown => 'Unknown';

  @override
  String get weatherToday => 'Weather Today';

  @override
  String get tapToSearch => 'Tap 🔍 to search\nfor your city';
}
