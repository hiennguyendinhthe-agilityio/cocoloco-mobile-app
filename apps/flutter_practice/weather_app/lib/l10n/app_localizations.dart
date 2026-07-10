import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @searchCityHint.
  ///
  /// In en, this message translates to:
  /// **'Ready to check the weather?'**
  String get searchCityHint;

  /// No description provided for @searchCityPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search city...'**
  String get searchCityPlaceholder;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @feelsLike.
  ///
  /// In en, this message translates to:
  /// **'Feels like'**
  String get feelsLike;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @wind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get wind;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @noWeatherSearchPrompt.
  ///
  /// In en, this message translates to:
  /// **'No weather data. Search for a city to get started.'**
  String get noWeatherSearchPrompt;

  /// No description provided for @tryAnotherSearch.
  ///
  /// In en, this message translates to:
  /// **'Try another search.'**
  String get tryAnotherSearch;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get theme;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @weatherToday.
  ///
  /// In en, this message translates to:
  /// **'Weather Today'**
  String get weatherToday;

  /// No description provided for @tapToSearch.
  ///
  /// In en, this message translates to:
  /// **'Tap 🔍 to search\nfor your city'**
  String get tapToSearch;

  /// No description provided for @locations.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get locations;

  /// No description provided for @weatherAlerts.
  ///
  /// In en, this message translates to:
  /// **'Weather Alerts'**
  String get weatherAlerts;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @goPremium.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get goPremium;

  /// No description provided for @premiumSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock advanced weather insights & ad-free experience'**
  String get premiumSubtitle;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'CURRENT LOCATION'**
  String get currentLocation;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'RECENT SEARCHES'**
  String get recentSearches;

  /// No description provided for @popularCities.
  ///
  /// In en, this message translates to:
  /// **'POPULAR CITIES'**
  String get popularCities;

  /// No description provided for @clearBtn.
  ///
  /// In en, this message translates to:
  /// **'CLEAR'**
  String get clearBtn;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @locating.
  ///
  /// In en, this message translates to:
  /// **'Locating...'**
  String get locating;

  /// No description provided for @tapToFindLocation.
  ///
  /// In en, this message translates to:
  /// **'Tap to find your location'**
  String get tapToFindLocation;

  /// No description provided for @couldNotAccessLocation.
  ///
  /// In en, this message translates to:
  /// **'Could not access location: {error}'**
  String couldNotAccessLocation(String error);

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get noInternetConnection;

  /// No description provided for @searchCityBtn.
  ///
  /// In en, this message translates to:
  /// **'Search City'**
  String get searchCityBtn;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @couldNotLoadForecast.
  ///
  /// In en, this message translates to:
  /// **'Could not load forecast'**
  String get couldNotLoadForecast;

  /// No description provided for @sevenDayForecast.
  ///
  /// In en, this message translates to:
  /// **'7-Day Forecast'**
  String get sevenDayForecast;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather App'**
  String get appTitle;

  /// No description provided for @london.
  ///
  /// In en, this message translates to:
  /// **'London'**
  String get london;

  /// No description provided for @tokyo.
  ///
  /// In en, this message translates to:
  /// **'Tokyo'**
  String get tokyo;

  /// No description provided for @newYork.
  ///
  /// In en, this message translates to:
  /// **'New York'**
  String get newYork;

  /// No description provided for @weatherConditions.
  ///
  /// In en, this message translates to:
  /// **'Weather Conditions'**
  String get weatherConditions;

  /// No description provided for @celsius.
  ///
  /// In en, this message translates to:
  /// **'Celsius (°C)'**
  String get celsius;

  /// No description provided for @actual.
  ///
  /// In en, this message translates to:
  /// **'Actual'**
  String get actual;

  /// No description provided for @feelsLikeWeather.
  ///
  /// In en, this message translates to:
  /// **'Feels like'**
  String get feelsLikeWeather;

  /// No description provided for @actualTempDesc.
  ///
  /// In en, this message translates to:
  /// **'Actual temperature.'**
  String get actualTempDesc;

  /// No description provided for @feelsLikeTempDesc.
  ///
  /// In en, this message translates to:
  /// **'Feels like temperature.'**
  String get feelsLikeTempDesc;

  /// No description provided for @probabilityOfPrecip.
  ///
  /// In en, this message translates to:
  /// **'Probability of precipitation'**
  String get probabilityOfPrecip;

  /// No description provided for @probabilityOnDay.
  ///
  /// In en, this message translates to:
  /// **'Probability of precipitation on {day}: {pop}%'**
  String probabilityOnDay(String day, String pop);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
