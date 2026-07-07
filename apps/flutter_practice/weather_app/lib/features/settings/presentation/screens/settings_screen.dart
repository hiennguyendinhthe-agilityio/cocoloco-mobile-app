import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/core/extensions/l10n_extension.dart';
import 'package:weather_app/core/localization/locale_provider.dart';
import 'package:weather_app/theme/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settings),
      ),
      body: ListView(
        children: [
          // Theme Toggle
          SwitchListTile(
            title: Text(context.l10n.theme),
            value: themeMode == ThemeMode.dark,
            onChanged: (value) {
              ref.read(themeModeProvider.notifier).setMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
            },
            secondary: const Icon(Icons.brightness_6),
          ),
          
          const Divider(),
          
          // Language Toggle
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(context.l10n.language),
            trailing: DropdownButton<String>(
              value: locale.languageCode,
              items: const [
                DropdownMenuItem(
                  value: 'en',
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: 'vi',
                  child: Text('Tiếng Việt'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(localeProvider.notifier).setLocale(Locale(value));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
