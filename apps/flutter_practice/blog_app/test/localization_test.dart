import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:blog_app/core/localization/app_localizations.dart';
import 'package:blog_app/core/localization/locale_provider.dart';
import 'package:blog_app/core/localization/translations/app_en.dart';
import 'package:blog_app/core/localization/translations/app_vi.dart';

void main() {
  group('LocaleNotifier Unit Tests', () {
    test('Initial locale defaults to English (en)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final locale = container.read(localeProvider);
      expect(locale.languageCode, equals('en'));
    });

    test('setLocale updates to Vietnamese (vi)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(localeProvider.notifier).setLocale(const Locale('vi'));
      final locale = container.read(localeProvider);
      expect(locale.languageCode, equals('vi'));
    });

    test('setLocale ignores unsupported locales', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(localeProvider.notifier).setLocale(const Locale('ja'));
      final locale = container.read(localeProvider);
      // Remains 'en'
      expect(locale.languageCode, equals('en'));
    });

    test('toggleLocale switches back and forth between en and vi', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(localeProvider.notifier);

      expect(container.read(localeProvider).languageCode, equals('en'));

      notifier.toggleLocale();
      expect(container.read(localeProvider).languageCode, equals('vi'));

      notifier.toggleLocale();
      expect(container.read(localeProvider).languageCode, equals('en'));
    });
  });

  group('AppLocalizations Contract & Completeness Tests', () {
    final en = AppLocalizationsEn();
    final vi = AppLocalizationsVi();

    test('All core translation keys return non-empty strings', () {
      // App & Branding
      expect(en.appTitle.isNotEmpty, isTrue);
      expect(vi.appTitle.isNotEmpty, isTrue);

      // Navigation
      expect(en.navHome, equals('Home'));
      expect(vi.navHome, equals('Trang chủ'));
      expect(en.navCart, equals('Cart'));
      expect(vi.navCart, equals('Giỏ hàng'));
      expect(en.navOrders, equals('Orders'));
      expect(vi.navOrders, equals('Đơn hàng'));

      // Categories
      expect(en.categoryAll, equals('All'));
      expect(vi.categoryAll, equals('Tất cả'));
      expect(en.categoryCoffee, equals('☕ Coffee'));
      expect(vi.categoryCoffee, equals('☕ Cà phê'));

      // Cart & Checkout
      expect(en.subtotal, equals('Subtotal'));
      expect(vi.subtotal, equals('Tạm tính'));
      expect(en.deliveryFee, equals('Delivery Fee'));
      expect(vi.deliveryFee, equals('Phí giao hàng'));
      expect(en.total, equals('Total'));
      expect(vi.total, equals('Tổng thanh toán'));
      expect(en.checkout, equals('Go to checkout'));
      expect(vi.checkout, equals('Tiến hành đặt hàng'));

      // Profile & Settings
      expect(en.displayLanguage, equals('Display Language'));
      expect(vi.displayLanguage, equals('Ngôn ngữ hiển thị'));
      expect(en.english, equals('English'));
      expect(vi.english, equals('English (Tiếng Anh)'));
      expect(en.vietnamese, equals('Vietnamese (Tiếng Việt)'));
      expect(vi.vietnamese, equals('Tiếng Việt'));
    });

    test('LocalizationsDelegate supports en and vi, rejects unsupported', () {
      const delegate = AppLocalizations.delegate;

      expect(delegate.isSupported(const Locale('en')), isTrue);
      expect(delegate.isSupported(const Locale('vi')), isTrue);
      expect(delegate.isSupported(const Locale('fr')), isFalse);
      expect(delegate.isSupported(const Locale('zh')), isFalse);
    });
  });

  group('Dynamic Runtime Localization Widget Tests', () {
    testWidgets('UI reacts dynamically to locale changes without restart',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              final locale = ref.watch(localeProvider);
              return MaterialApp(
                locale: locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                home: Builder(
                  builder: (innerContext) {
                    return Scaffold(
                      body: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(innerContext.l10n.subtotal),
                            Text(innerContext.l10n.navHome),
                            ElevatedButton(
                              onPressed: () {
                                ref.read(localeProvider.notifier).toggleLocale();
                              },
                              child: const Text('Toggle Language'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initial state is English
      expect(find.text('Subtotal'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Tạm tính'), findsNothing);
      expect(find.text('Trang chủ'), findsNothing);

      // Tap toggle button to switch to Vietnamese
      await tester.tap(find.text('Toggle Language'));
      await tester.pumpAndSettle();

      // State is now Vietnamese
      expect(find.text('Subtotal'), findsNothing);
      expect(find.text('Home'), findsNothing);
      expect(find.text('Tạm tính'), findsOneWidget);
      expect(find.text('Trang chủ'), findsOneWidget);

      // Tap again to switch back to English
      await tester.tap(find.text('Toggle Language'));
      await tester.pumpAndSettle();

      // Back to English
      expect(find.text('Subtotal'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Tạm tính'), findsNothing);
      expect(find.text('Trang chủ'), findsNothing);
    });
  });
}
