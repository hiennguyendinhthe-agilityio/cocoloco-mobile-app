import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_localizations.dart';

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    return const Locale('en');
  }

  void setLocale(Locale newLocale) {
    final isSupported = AppLocalizations.supportedLocales.any(
      (loc) => loc.languageCode == newLocale.languageCode,
    );
    if (!isSupported) return;

    if (state.languageCode != newLocale.languageCode) {
      state = newLocale;
    }
  }

  void toggleLocale() {
    if (state.languageCode == 'en') {
      state = const Locale('vi');
    } else {
      state = const Locale('en');
    }
  }

  bool get isVietnamese => state.languageCode == 'vi';
  bool get isEnglish => state.languageCode == 'en';
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});
