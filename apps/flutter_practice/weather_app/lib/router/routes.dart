// Route name constants.
//
// Single source of truth for all named route paths and names.
// No GoRoute objects here — only string identifiers.
//
// Rules:
//   - Path strings begin with '/'.
//   - Names are camelCase, unique, and match the path leaf.
//   - Sub-routes use relative paths (no leading '/').

abstract final class AppRoutes {
  AppRoutes._();

  // ── Root ──────────────────────────────────────────────────────────────────

  static const String splashPath = '/';
  static const String splashName = 'splash';

  static const String homePath = '/home';
  static const String homeName = 'home';

  // ── Placeholder for future expansion ──────────────────────────────────────
  // e.g.:
  // static const String searchPath = 'search';
  // static const String searchName = 'search';
  //
  static const String settingsPath = '/settings';
  static const String settingsName = 'settings';
}
