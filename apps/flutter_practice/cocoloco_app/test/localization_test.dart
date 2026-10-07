import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cocoloco_app/core/localization/app_localizations.dart';
import 'package:cocoloco_app/core/localization/locale_provider.dart';
import 'package:cocoloco_app/core/localization/translations/app_en.dart';
import 'package:cocoloco_app/core/localization/translations/app_vi.dart';

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

    void assertAllGetters(AppLocalizations l10n) {
      expect(l10n.locale, isNotNull);
      expect(l10n.appTitle.isNotEmpty, isTrue);
      expect(l10n.appTagline.isNotEmpty, isTrue);
      expect(l10n.cancel.isNotEmpty, isTrue);
      expect(l10n.save.isNotEmpty, isTrue);
      expect(l10n.confirm.isNotEmpty, isTrue);
      expect(l10n.delete.isNotEmpty, isTrue);
      expect(l10n.edit.isNotEmpty, isTrue);
      expect(l10n.close.isNotEmpty, isTrue);
      expect(l10n.done.isNotEmpty, isTrue);
      expect(l10n.retry.isNotEmpty, isTrue);
      expect(l10n.search.isNotEmpty, isTrue);
      expect(l10n.searchPlaceholder.isNotEmpty, isTrue);
      expect(l10n.comingSoon.isNotEmpty, isTrue);
      expect(l10n.comingSoonMsg.isNotEmpty, isTrue);
      expect(l10n.ok.isNotEmpty, isTrue);
      expect(l10n.error.isNotEmpty, isTrue);
      expect(l10n.success.isNotEmpty, isTrue);
      expect(l10n.loading.isNotEmpty, isTrue);

      expect(l10n.navHome.isNotEmpty, isTrue);
      expect(l10n.navFavorites.isNotEmpty, isTrue);
      expect(l10n.navOrders.isNotEmpty, isTrue);
      expect(l10n.navChat.isNotEmpty, isTrue);
      expect(l10n.navCart.isNotEmpty, isTrue);

      expect(l10n.categoryAll.isNotEmpty, isTrue);
      expect(l10n.categoryCoffee.isNotEmpty, isTrue);
      expect(l10n.categoryBakery.isNotEmpty, isTrue);
      expect(l10n.categoryCombos.isNotEmpty, isTrue);
      expect(l10n.categorySpecials.isNotEmpty, isTrue);

      expect(l10n.letsGetThisDayGoing.isNotEmpty, isTrue);
      expect(l10n.aprilSpecial.isNotEmpty, isTrue);
      expect(l10n.featuredOffers.isNotEmpty, isTrue);
      expect(l10n.dailySpecial.isNotEmpty, isTrue);
      expect(l10n.bestSellers.isNotEmpty, isTrue);
      expect(l10n.addedToOrder('Latte').isNotEmpty, isTrue);
      expect(l10n.outOfStock.isNotEmpty, isTrue);
      expect(l10n.available.isNotEmpty, isTrue);
      expect(l10n.viewCart.isNotEmpty, isTrue);
      expect(l10n.addToOrder.isNotEmpty, isTrue);
      expect(l10n.updateCart.isNotEmpty, isTrue);
      expect(l10n.cartUpdated.isNotEmpty, isTrue);
      expect(l10n.orderNow.isNotEmpty, isTrue);
      expect(l10n.noProductsFound.isNotEmpty, isTrue);
      expect(l10n.noProductsSub.isNotEmpty, isTrue);

      expect(l10n.customization.isNotEmpty, isTrue);
      expect(l10n.size.isNotEmpty, isTrue);
      expect(l10n.regular.isNotEmpty, isTrue);
      expect(l10n.large.isNotEmpty, isTrue);
      expect(l10n.sweetness.isNotEmpty, isTrue);
      expect(l10n.iceLevel.isNotEmpty, isTrue);
      expect(l10n.milkOption.isNotEmpty, isTrue);
      expect(l10n.reviews.isNotEmpty, isTrue);
      expect(l10n.description.isNotEmpty, isTrue);
      expect(l10n.ingredients.isNotEmpty, isTrue);

      expect(l10n.cartTitle.isNotEmpty, isTrue);
      expect(l10n.cartEmptyTitle.isNotEmpty, isTrue);
      expect(l10n.cartEmptySubtitle.isNotEmpty, isTrue);
      expect(l10n.subtotal.isNotEmpty, isTrue);
      expect(l10n.deliveryFee.isNotEmpty, isTrue);
      expect(l10n.total.isNotEmpty, isTrue);
      expect(l10n.freeDelivery.isNotEmpty, isTrue);
      expect(l10n.checkout.isNotEmpty, isTrue);
      expect(l10n.checkoutProcessing.isNotEmpty, isTrue);
      expect(l10n.clearCart.isNotEmpty, isTrue);
      expect(l10n.clearCartConfirm.isNotEmpty, isTrue);
      expect(l10n.orderFailed.isNotEmpty, isTrue);

      expect(l10n.orderedTitle.isNotEmpty, isTrue);
      expect(l10n.orderedSubtitle.isNotEmpty, isTrue);
      expect(l10n.okayGotIt.isNotEmpty, isTrue);

      expect(l10n.yourOrders.isNotEmpty, isTrue);
      expect(l10n.trackReceipts.isNotEmpty, isTrue);
      expect(l10n.allOrders.isNotEmpty, isTrue);
      expect(l10n.pending.isNotEmpty, isTrue);
      expect(l10n.brewing.isNotEmpty, isTrue);
      expect(l10n.completed.isNotEmpty, isTrue);
      expect(l10n.cancelled.isNotEmpty, isTrue);
      expect(l10n.reorder.isNotEmpty, isTrue);
      expect(l10n.noOrdersYet.isNotEmpty, isTrue);
      expect(l10n.noOrdersSubtitle.isNotEmpty, isTrue);
      expect(l10n.loginToViewOrders.isNotEmpty, isTrue);
      expect(l10n.loginPromptSubtitle.isNotEmpty, isTrue);
      expect(l10n.ordersCount(5).isNotEmpty, isTrue);

      expect(l10n.cocolocoAccount.isNotEmpty, isTrue);
      expect(l10n.signInPrompt.isNotEmpty, isTrue);
      expect(l10n.signInSubtitle.isNotEmpty, isTrue);
      expect(l10n.signInButton.isNotEmpty, isTrue);
      expect(l10n.goldMember.isNotEmpty, isTrue);
      expect(l10n.memberId.isNotEmpty, isTrue);
      expect(l10n.cocolocoBeans.isNotEmpty, isTrue);
      expect(l10n.redeemGifts.isNotEmpty, isTrue);
      expect(l10n.ordersAndTransactions.isNotEmpty, isTrue);
      expect(l10n.orderHistory.isNotEmpty, isTrue);
      expect(l10n.orderHistorySub.isNotEmpty, isTrue);
      expect(l10n.savedAddresses.isNotEmpty, isTrue);
      expect(l10n.savedAddressesSub.isNotEmpty, isTrue);
      expect(l10n.paymentMethods.isNotEmpty, isTrue);
      expect(l10n.paymentMethodsSub.isNotEmpty, isTrue);
      expect(l10n.vouchersAndOffers.isNotEmpty, isTrue);
      expect(l10n.vouchersSub.isNotEmpty, isTrue);
      expect(l10n.settingsAndUtilities.isNotEmpty, isTrue);
      expect(l10n.pushNotifications.isNotEmpty, isTrue);
      expect(l10n.notificationsSub.isNotEmpty, isTrue);
      expect(l10n.accountSecurity.isNotEmpty, isTrue);
      expect(l10n.securitySub.isNotEmpty, isTrue);
      expect(l10n.secure.isNotEmpty, isTrue);
      expect(l10n.displayLanguage.isNotEmpty, isTrue);
      expect(l10n.currentLanguageName.isNotEmpty, isTrue);
      expect(l10n.selectLanguage.isNotEmpty, isTrue);
      expect(l10n.english.isNotEmpty, isTrue);
      expect(l10n.vietnamese.isNotEmpty, isTrue);
      expect(l10n.infoAndSupport.isNotEmpty, isTrue);
      expect(l10n.customerSupport.isNotEmpty, isTrue);
      expect(l10n.hotlineSub.isNotEmpty, isTrue);
      expect(l10n.termsAndPolicies.isNotEmpty, isTrue);
      expect(l10n.termsSub.isNotEmpty, isTrue);
      expect(l10n.appVersion.isNotEmpty, isTrue);
      expect(l10n.signOut.isNotEmpty, isTrue);
      expect(l10n.signOutConfirm.isNotEmpty, isTrue);
      expect(l10n.signedOutSuccessfully.isNotEmpty, isTrue);

      expect(l10n.adminDashboard.isNotEmpty, isTrue);
      expect(l10n.adminProductsTitle.isNotEmpty, isTrue);
      expect(l10n.adminProductsSubtitle.isNotEmpty, isTrue);
      expect(l10n.addProduct.isNotEmpty, isTrue);
      expect(l10n.editProduct.isNotEmpty, isTrue);
      expect(l10n.deleteProductConfirm('Latte').isNotEmpty, isTrue);
      expect(l10n.deleteProductWarning.isNotEmpty, isTrue);
      expect(l10n.productConflictError.isNotEmpty, isTrue);
      expect(l10n.productName.isNotEmpty, isTrue);
      expect(l10n.productPrice.isNotEmpty, isTrue);
      expect(l10n.productCategory.isNotEmpty, isTrue);
      expect(l10n.productDescription.isNotEmpty, isTrue);
      expect(l10n.productImageUrl.isNotEmpty, isTrue);
      expect(l10n.isAvailable.isNotEmpty, isTrue);

      expect(l10n.welcomeToCocoloco.isNotEmpty, isTrue);
      expect(l10n.signInSubtitleModal.isNotEmpty, isTrue);
      expect(l10n.continueWithGoogle.isNotEmpty, isTrue);
      expect(l10n.orWithEmail.isNotEmpty, isTrue);
      expect(l10n.enterEmailAddress.isNotEmpty, isTrue);
      expect(l10n.sendOtpCode.isNotEmpty, isTrue);
      expect(l10n.guestCheckoutPrompt.isNotEmpty, isTrue);
      expect(l10n.syncingWithBackend.isNotEmpty, isTrue);
      expect(l10n.signedInSuccessfully.isNotEmpty, isTrue);
      expect(l10n.syncFailed.isNotEmpty, isTrue);

      expect(l10n.themeModeTitle.isNotEmpty, isTrue);
      expect(l10n.themeLight.isNotEmpty, isTrue);
      expect(l10n.themeDark.isNotEmpty, isTrue);
      expect(l10n.themeSystem.isNotEmpty, isTrue);
      expect(l10n.themeLightSubtitle.isNotEmpty, isTrue);
      expect(l10n.themeDarkSubtitle.isNotEmpty, isTrue);
      expect(l10n.themeSystemSubtitle.isNotEmpty, isTrue);
    }

    test('All English translation getters return non-empty strings', () {
      assertAllGetters(en);
    });

    test('All Vietnamese translation getters return non-empty strings', () {
      assertAllGetters(vi);
    });

    test('LocalizationsDelegate supports en and vi, rejects unsupported and loads correctly', () async {
      const delegate = AppLocalizations.delegate;

      expect(delegate.isSupported(const Locale('en')), isTrue);
      expect(delegate.isSupported(const Locale('vi')), isTrue);
      expect(delegate.isSupported(const Locale('fr')), isFalse);
      expect(delegate.isSupported(const Locale('zh')), isFalse);

      final loadedEn = await delegate.load(const Locale('en'));
      expect(loadedEn, isA<AppLocalizationsEn>());

      final loadedVi = await delegate.load(const Locale('vi'));
      expect(loadedVi, isA<AppLocalizationsVi>());

      expect(delegate.shouldReload(delegate), isFalse);
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
