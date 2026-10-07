import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../core/localization/app_localizations.dart';
import '../core/localization/locale_provider.dart';
import '../core/providers/theme_mode_provider.dart';
import '../core/services/session_service.dart';
import '../core/theme/app_theme.dart';
import '../models/user_profile.dart';

/// Dedicated Settings & Preferences screen for Cocoloco.
///
/// Houses app preferences (Theme, Language, Notifications, Security)
/// and system information (Customer support, Policies, Version).
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final SessionService _session = SessionService.instance;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _session.addListener(_onSessionChanged);
  }

  @override
  void dispose() {
    _session.removeListener(_onSessionChanged);
    super.dispose();
  }

  void _onSessionChanged() {
    if (mounted) setState(() {});
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSecurityDialog() {
    final role = _session.role;
    final user = _session.user;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: context.colorScheme.surface,
        title: Row(
          children: const [
            Icon(Icons.verified_user_rounded, color: Color(0xFF2E7D32), size: 26),
            SizedBox(width: 10),
            Text(
              'Account Security',
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.25)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Clerk RS256 JWKS Active Guard',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Your session is protected with asymmetric cryptographic signature verification. All requests to the Cocoloco FastAPI backend require valid RS256 Bearer tokens.',
              style: TextStyle(
                fontSize: 13,
                color: context.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            if (user != null) ...[
              const SizedBox(height: 12),
              Text(
                'Account: ${user.email.isNotEmpty ? user.email : user.fullName}',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.onSurface,
                ),
              ),
              Text(
                'Role: ${role.name.toUpperCase()}',
                style: TextStyle(
                  fontSize: 12,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
              foregroundColor: context.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: const Text('Understood', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector() {
    final currentLocale = ref.read(localeProvider);
    final l10n = context.l10n;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: context.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  l10n.selectLanguage,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: context.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                _buildLanguageOption(
                  locale: const Locale('en'),
                  title: l10n.english,
                  flag: '🇬🇧',
                  isSelected: currentLocale.languageCode == 'en',
                  onTap: () {
                    ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                    Navigator.pop(ctx);
                  },
                ),
                const SizedBox(height: 10),
                _buildLanguageOption(
                  locale: const Locale('vi'),
                  title: l10n.vietnamese,
                  flag: '🇻🇳',
                  isSelected: currentLocale.languageCode == 'vi',
                  onTap: () {
                    ref.read(localeProvider.notifier).setLocale(const Locale('vi'));
                    Navigator.pop(ctx);
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required Locale locale,
    required String title,
    required String flag,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isSelected ? context.colorScheme.surfaceContainerHighest : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? context.colorScheme.primary : context.colorScheme.outlineVariant,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? context.colorScheme.primary : context.colorScheme.onSurface,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: context.colorScheme.primary,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeSelector() {
    final currentThemeMode = ref.read(themeModeProvider);
    final l10n = context.l10n;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: context.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                    ),
                  ),
                ),
                Text(
                  l10n.themeModeTitle,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: context.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                _buildThemeOption(
                  ctx: ctx,
                  mode: ThemeMode.light,
                  title: l10n.themeLight,
                  subtitle: l10n.themeLightSubtitle,
                  icon: Icons.light_mode_rounded,
                  isSelected: currentThemeMode == ThemeMode.light,
                ),
                const SizedBox(height: 10),
                _buildThemeOption(
                  ctx: ctx,
                  mode: ThemeMode.dark,
                  title: l10n.themeDark,
                  subtitle: l10n.themeDarkSubtitle,
                  icon: Icons.dark_mode_rounded,
                  isSelected: currentThemeMode == ThemeMode.dark,
                ),
                const SizedBox(height: 10),
                _buildThemeOption(
                  ctx: ctx,
                  mode: ThemeMode.system,
                  title: l10n.themeSystem,
                  subtitle: l10n.themeSystemSubtitle,
                  icon: Icons.brightness_auto_rounded,
                  isSelected: currentThemeMode == ThemeMode.system,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption({
    required BuildContext ctx,
    required ThemeMode mode,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
  }) {
    return Material(
      color: isSelected
          ? context.colorScheme.surfaceContainerHighest
          : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        onTap: () {
          ref.read(themeModeProvider.notifier).setThemeMode(mode);
          Navigator.pop(ctx);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(
              color: isSelected
                  ? context.colorScheme.primary
                  : context.colorScheme.outlineVariant,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected
                            ? context.colorScheme.primary
                            : context.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: context.colorScheme.primary,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout() {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: context.colorScheme.surface,
        title: Row(
          children: [
            const Icon(Icons.logout_rounded, color: Color(0xFFC53030), size: 24),
            const SizedBox(width: 10),
            Text(
              l10n.signOut,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: context.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        content: Text(
          l10n.signOutConfirm,
          style: TextStyle(fontSize: 14, color: context.colorScheme.onSurfaceVariant, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: context.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await WebViewCookieManager().clearCookies();
              } catch (_) {}
              _session.logout();
              if (mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.signedOutSuccessfully),
                    backgroundColor: AppColors.primary,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC53030),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(
              l10n.signOut,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentLocale = ref.watch(localeProvider);
    final currentThemeMode = ref.watch(themeModeProvider);
    final bool isLoggedIn = _session.role != AppRole.guest;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: context.colorScheme.onSurface),
        centerTitle: true,
        title: Text(
          l10n.settingsAndUtilities,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: context.colorScheme.onSurface,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Section: Settings & Utilities
              _buildSectionHeader(l10n.settingsAndUtilities),
              _buildMenuCard([
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.notifications_outlined, color: context.colorScheme.primary, size: 22),
                  ),
                  title: Text(
                    l10n.pushNotifications,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: context.colorScheme.onSurface),
                  ),
                  subtitle: Text(
                    l10n.notificationsSub,
                    style: TextStyle(fontSize: 12.5, color: context.colorScheme.onSurfaceVariant),
                  ),
                  trailing: Switch.adaptive(
                    value: _notificationsEnabled,
                    activeTrackColor: context.colorScheme.primary,
                    onChanged: (val) {
                      setState(() {
                        _notificationsEnabled = val;
                      });
                    },
                  ),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.verified_user_outlined,
                  title: l10n.accountSecurity,
                  subtitle: l10n.securitySub,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 18),
                      const SizedBox(width: 4),
                      Text(l10n.secure, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF2E7D32))),
                    ],
                  ),
                  onTap: _showSecurityDialog,
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.language_rounded,
                  title: l10n.displayLanguage,
                  subtitle: currentLocale.languageCode == 'vi'
                      ? 'Tiếng Việt (Vietnamese)'
                      : 'English (Tiếng Anh)',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: context.colorScheme.outlineVariant),
                        ),
                        child: Text(
                          currentLocale.languageCode == 'vi' ? '🇻🇳 VI' : '🇬🇧 EN',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios_rounded, size: 14, color: context.colorScheme.outlineVariant),
                    ],
                  ),
                  onTap: _showLanguageSelector,
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: currentThemeMode == ThemeMode.dark
                      ? Icons.dark_mode_rounded
                      : (currentThemeMode == ThemeMode.light
                          ? Icons.light_mode_rounded
                          : Icons.brightness_auto_rounded),
                  title: l10n.themeModeTitle,
                  subtitle: currentThemeMode == ThemeMode.dark
                      ? l10n.themeDark
                      : (currentThemeMode == ThemeMode.light
                          ? l10n.themeLight
                          : l10n.themeSystem),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: context.colorScheme.outlineVariant),
                        ),
                        child: Text(
                          currentThemeMode == ThemeMode.dark
                              ? '🌙 Dark'
                              : (currentThemeMode == ThemeMode.light
                                  ? '☀️ Light'
                                  : '⚙️ Auto'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios_rounded, size: 14, color: context.colorScheme.outlineVariant),
                    ],
                  ),
                  onTap: _showThemeSelector,
                ),
              ]),

              const SizedBox(height: 20),

              // 2. Section: Support & Info
              _buildSectionHeader(l10n.infoAndSupport),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.headset_mic_outlined,
                  title: l10n.customerSupport,
                  subtitle: l10n.hotlineSub,
                  onTap: () => _showComingSoon('Call Hotline'),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.policy_outlined,
                  title: l10n.termsAndPolicies,
                  subtitle: l10n.termsSub,
                  onTap: () => _showComingSoon(l10n.termsAndPolicies),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.info_outline_rounded,
                  title: l10n.appVersion,
                  subtitle: 'Cocoloco Mobile App v1.0.0 (FastAPI 3.12+)',
                  trailing: Text(
                    'v1.0.0',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.colorScheme.onSurfaceVariant),
                  ),
                  onTap: () {},
                ),
              ]),

              // 3. Logout Option in Settings
              if (isLoggedIn) ...[
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: _confirmLogout,
                    icon: Icon(Icons.logout_rounded, color: context.colorScheme.error, size: 20),
                    label: Text(
                      l10n.signOut,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: context.colorScheme.error,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: context.colorScheme.error.withValues(alpha: 0.35), width: 1.5),
                      backgroundColor: context.colorScheme.error.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: context.colorScheme.onSurfaceVariant,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: Column(children: children),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: context.colorScheme.primary, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15,
          color: context.colorScheme.onSurface,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(fontSize: 12.5, color: context.colorScheme.onSurfaceVariant),
            )
          : null,
      trailing: trailing ?? Icon(Icons.arrow_forward_ios_rounded, size: 14, color: context.colorScheme.outlineVariant),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 62, endIndent: 16, color: context.colorScheme.outlineVariant);
  }
}
