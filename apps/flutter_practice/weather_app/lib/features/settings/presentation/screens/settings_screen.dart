// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/core/extensions/l10n_extension.dart';
import 'package:weather_app/features/settings/domain/entities/app_settings.dart';
import 'package:weather_app/features/settings/presentation/controllers/settings_controller.dart';
// Note: We are migrating away from the standalone theme/locale providers to the consolidated SettingsController.
import 'package:weather_app/theme/providers/theme_provider.dart';
import 'package:weather_app/core/localization/locale_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settings),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
      ),
      body: settingsState.when(
        data: (settings) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            _buildThemeSection(context, ref, settings),
            const Divider(),
            _buildUnitSection(context, ref, settings),
            const Divider(),
            _buildLanguageSection(context, ref, settings),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading settings: $err')),
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context, WidgetRef ref, AppSettings settings) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            context.l10n.theme,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
        RadioListTile<ThemeMode>(
          title: const Text('System Default'),
          value: ThemeMode.system,
          groupValue: settings.themeMode,
          onChanged: (mode) {
            if (mode != null) {
              ref.read(settingsControllerProvider.notifier).updateThemeMode(mode);
              // Maintain legacy provider sync for now
              ref.read(themeModeProvider.notifier).setMode(mode);
            }
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Light'),
          value: ThemeMode.light,
          groupValue: settings.themeMode,
          onChanged: (mode) {
            if (mode != null) {
              ref.read(settingsControllerProvider.notifier).updateThemeMode(mode);
              ref.read(themeModeProvider.notifier).setMode(mode);
            }
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Dark'),
          value: ThemeMode.dark,
          groupValue: settings.themeMode,
          onChanged: (mode) {
            if (mode != null) {
              ref.read(settingsControllerProvider.notifier).updateThemeMode(mode);
              ref.read(themeModeProvider.notifier).setMode(mode);
            }
          },
        ),
      ],
    );
  }

  Widget _buildUnitSection(BuildContext context, WidgetRef ref, AppSettings settings) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Temperature Unit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
        RadioListTile<TemperatureUnit>(
          title: const Text('Celsius (°C)'),
          value: TemperatureUnit.celsius,
          groupValue: settings.temperatureUnit,
          onChanged: (unit) {
            if (unit != null) ref.read(settingsControllerProvider.notifier).updateTemperatureUnit(unit);
          },
        ),
        RadioListTile<TemperatureUnit>(
          title: const Text('Fahrenheit (°F)'),
          value: TemperatureUnit.fahrenheit,
          groupValue: settings.temperatureUnit,
          onChanged: (unit) {
            if (unit != null) ref.read(settingsControllerProvider.notifier).updateTemperatureUnit(unit);
          },
        ),
      ],
    );
  }

  Widget _buildLanguageSection(BuildContext context, WidgetRef ref, AppSettings settings) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            context.l10n.language,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
        RadioListTile<Locale>(
          title: const Text('Tiếng Việt'),
          value: const Locale('vi'),
          groupValue: settings.locale,
          onChanged: (locale) {
            if (locale != null) {
              ref.read(settingsControllerProvider.notifier).updateLocale(locale);
              // Maintain legacy provider sync for now
              ref.read(localeProvider.notifier).setLocale(locale);
            }
          },
        ),
        RadioListTile<Locale>(
          title: const Text('English'),
          value: const Locale('en'),
          groupValue: settings.locale,
          onChanged: (locale) {
            if (locale != null) {
              ref.read(settingsControllerProvider.notifier).updateLocale(locale);
              ref.read(localeProvider.notifier).setLocale(locale);
            }
          },
        ),
      ],
    );
  }
}
