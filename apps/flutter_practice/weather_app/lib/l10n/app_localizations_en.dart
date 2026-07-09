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
  String get searchCityPlaceholder => 'Search city...';

  @override
  String get cancel => 'Cancel';

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

  @override
  String get locations => 'Locations';

  @override
  String get weatherAlerts => 'Weather Alerts';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get goPremium => 'Go Premium';

  @override
  String get premiumSubtitle =>
      'Unlock advanced weather insights & ad-free experience';

  @override
  String get currentLocation => 'CURRENT LOCATION';

  @override
  String get recentSearches => 'RECENT SEARCHES';

  @override
  String get popularCities => 'POPULAR CITIES';

  @override
  String get clearBtn => 'CLEAR';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get locating => 'Locating...';

  @override
  String get tapToFindLocation => 'Tap to find your location';

  @override
  String couldNotAccessLocation(String error) {
    return 'Could not access location: $error';
  }

  @override
  String get noInternetConnection =>
      'No internet connection. Please check your network and try again.';

  @override
  String get searchCityBtn => 'Search City';

  @override
  String get viewAll => 'View all';

  @override
  String get couldNotLoadForecast => 'Could not load forecast';

  @override
  String get sevenDayForecast => '7-Day Forecast';

  @override
  String get now => 'Now';

  @override
  String get appTitle => 'Weather App';

  @override
  String get london => 'London';

  @override
  String get tokyo => 'Tokyo';

  @override
  String get newYork => 'New York';
}
