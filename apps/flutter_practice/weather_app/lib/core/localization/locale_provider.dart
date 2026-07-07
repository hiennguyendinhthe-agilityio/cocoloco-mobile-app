import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/core/storage/preferences_service.dart';

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final prefs = ref.watch(preferencesServiceProvider);
    final savedLang = prefs.getLanguageCode();
    if (savedLang != null) {
      return Locale(savedLang);
    }
    return const Locale('en'); // Default language
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = ref.read(preferencesServiceProvider);
    await prefs.saveLanguageCode(locale.languageCode);
  }
}
