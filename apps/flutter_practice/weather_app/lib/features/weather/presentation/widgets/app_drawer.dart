import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/extensions/l10n_extension.dart';
import 'package:weather_app/router/routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 35),
                ),
                SizedBox(height: 12),
                Text(
                  'Agility IO Training',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(context.l10n.home),
            onTap: () {
              context.pop(); // Close drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(context.l10n.profile),
            onTap: () {
              context.pop();
              // context.push(AppRoutes.profilePath);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(context.l10n.settings),
            onTap: () {
              context.pop();
              context.push(AppRoutes.settingsPath);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              context.l10n.logout,
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              context.pop();
              // Handle logout
            },
          ),
        ],
      ),
    );
  }
}
