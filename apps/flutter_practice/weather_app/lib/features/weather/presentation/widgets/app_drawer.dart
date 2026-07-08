import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/extensions/l10n_extension.dart';
import 'package:weather_app/features/weather/presentation/widgets/drawer_nav_item.dart';
import 'package:weather_app/features/weather/presentation/widgets/drawer_profile_header.dart';
import 'package:weather_app/features/weather/presentation/widgets/premium_upgrade_card.dart';
import 'package:weather_app/router/routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Stack(
        children: [
          // Bottom Background Image
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                'assets/images/bg_sunny.png',
                fit: BoxFit.cover,
                // Add a gradient mask to fade the image at the top
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.5),
                colorBlendMode: BlendMode.dstOut,
              ),
            ),
          ),

          // Foreground Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const DrawerProfileHeader(),
                const PremiumUpgradeCard(),
                const SizedBox(height: 16),

                // Navigation Items
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerNavItem(
                        icon: Icons.home,
                        title: context.l10n.home,
                        isSelected: true,
                        onTap: () {
                          context.pop();
                        },
                      ),
                      DrawerNavItem(
                        icon: Icons.person,
                        title: context.l10n.profile,
                        onTap: () {
                          context.pop();
                          // context.push(AppRoutes.profilePath);
                        },
                      ),
                      DrawerNavItem(
                        icon: Icons.location_on_outlined,
                        title: context.l10n.locations,
                        onTap: () {
                          context.pop();
                          // Handle locations
                        },
                      ),
                      DrawerNavItem(
                        icon: Icons.notifications_none,
                        title: context.l10n.weatherAlerts,
                        onTap: () {
                          context.pop();
                          // Handle alerts
                        },
                      ),
                      DrawerNavItem(
                        icon: Icons.settings_outlined,
                        title: context.l10n.settings,
                        onTap: () {
                          context.pop();
                          context.push(AppRoutes.settingsPath);
                        },
                      ),
                      DrawerNavItem(
                        icon: Icons.help_outline,
                        title: context.l10n.helpSupport,
                        onTap: () {
                          context.pop();
                          // Handle help & support
                        },
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Divider(height: 1, thickness: 1),
                ),

                // Logout Action
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
                  child: DrawerNavItem(
                    icon: Icons.logout,
                    title: context.l10n.logout,
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () {
                      context.pop();
                      // Handle logout
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
