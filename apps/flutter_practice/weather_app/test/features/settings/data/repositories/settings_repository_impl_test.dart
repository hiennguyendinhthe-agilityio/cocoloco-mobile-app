import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:weather_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:weather_app/features/settings/domain/entities/app_settings.dart';

class MockSettingsLocalDataSource extends Mock implements SettingsLocalDataSource {}

void main() {
  late SettingsRepositoryImpl repository;
  late MockSettingsLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockSettingsLocalDataSource();
    repository = SettingsRepositoryImpl(mockDataSource);
  });

  group('SettingsRepositoryImpl', () {
    const tSettings = AppSettings(
      themeMode: ThemeMode.dark,
      temperatureUnit: TemperatureUnit.fahrenheit,
      locale: Locale('en'),
    );

    test('getSettings should return AppSettings from local data source', () async {
      when(() => mockDataSource.getSettings()).thenAnswer((_) async => tSettings);

      final result = await repository.getSettings();

      expect(result, equals(tSettings));
      verify(() => mockDataSource.getSettings()).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    test('saveSettings should call saveSettings on local data source', () async {
      when(() => mockDataSource.saveSettings(tSettings)).thenAnswer((_) async {});

      await repository.saveSettings(tSettings);

      verify(() => mockDataSource.saveSettings(tSettings)).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });
  });
}
