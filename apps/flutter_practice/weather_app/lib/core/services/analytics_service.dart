import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  AnalyticsService._privateConstructor();
  static final AnalyticsService instance = AnalyticsService._privateConstructor();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalytics get analytics => _analytics;

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> logSearchCity(String cityName) async {
    try {
      await _analytics.logEvent(
        name: 'search_city',
        parameters: {
          'city_name': cityName,
        },
      );
      if (kDebugMode) {
        print('Analytics: Logged search_city -> $cityName');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics Error: $e');
      }
    }
  }

  Future<void> logWeatherRefreshed(String cityName) async {
    try {
      await _analytics.logEvent(
        name: 'weather_refreshed',
        parameters: {
          'city_name': cityName,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Analytics Error: $e');
      }
    }
  }
}
