import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'translations/app_en.dart';
import 'translations/app_vi.dart';

abstract class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizationsEn();
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('vi'),
  ];

  // -------------------------------------------------------------
  // Common / General
  // -------------------------------------------------------------
  String get appTitle;
  String get appTagline;
  String get cancel;
  String get save;
  String get confirm;
  String get delete;
  String get edit;
  String get close;
  String get done;
  String get retry;
  String get search;
  String get searchPlaceholder;
  String get comingSoon;
  String get comingSoonMsg;
  String get ok;
  String get error;
  String get success;
  String get loading;

  // -------------------------------------------------------------
  // Navigation
  // -------------------------------------------------------------
  String get navHome;
  String get navFavorites;
  String get navOrders;
  String get navChat;
  String get navCart;

  // -------------------------------------------------------------
  // Categories
  // -------------------------------------------------------------
  String get categoryAll;
  String get categoryCoffee;
  String get categoryBakery;
  String get categoryCombos;
  String get categorySpecials;

  // -------------------------------------------------------------
  // Product Catalog & Browse
  // -------------------------------------------------------------
  String get letsGetThisDayGoing;
  String get aprilSpecial;
  String get featuredOffers;
  String get dailySpecial;
  String get bestSellers;
  String addedToOrder(String item);
  String get outOfStock;
  String get available;
  String get viewCart;
  String get addToOrder;
  String get updateCart;
  String get cartUpdated;
  String get orderNow;
  String get noProductsFound;
  String get noProductsSub;

  // -------------------------------------------------------------
  // Product Detail
  // -------------------------------------------------------------
  String get customization;
  String get size;
  String get regular;
  String get large;
  String get sweetness;
  String get iceLevel;
  String get milkOption;
  String get reviews;
  String get description;
  String get ingredients;

  // -------------------------------------------------------------
  // Cart & Checkout
  // -------------------------------------------------------------
  String get cartTitle;
  String get cartEmptyTitle;
  String get cartEmptySubtitle;
  String get subtotal;
  String get deliveryFee;
  String get total;
  String get freeDelivery;
  String get checkout;
  String get checkoutProcessing;
  String get clearCart;
  String get clearCartConfirm;
  String get orderFailed;

  // -------------------------------------------------------------
  // Order Success
  // -------------------------------------------------------------
  String get orderedTitle;
  String get orderedSubtitle;
  String get okayGotIt;

  // -------------------------------------------------------------
  // Orders Screen
  // -------------------------------------------------------------
  String get yourOrders;
  String get trackReceipts;
  String get allOrders;
  String get pending;
  String get brewing;
  String get completed;
  String get cancelled;
  String get reorder;
  String get noOrdersYet;
  String get noOrdersSubtitle;
  String get loginToViewOrders;
  String get loginPromptSubtitle;
  String ordersCount(int count);

  // -------------------------------------------------------------
  // Profile & Settings
  // -------------------------------------------------------------
  String get cocolocoAccount;
  String get signInPrompt;
  String get signInSubtitle;
  String get signInButton;
  String get goldMember;
  String get memberId;
  String get cocolocoBeans;
  String get redeemGifts;
  String get ordersAndTransactions;
  String get orderHistory;
  String get orderHistorySub;
  String get savedAddresses;
  String get savedAddressesSub;
  String get paymentMethods;
  String get paymentMethodsSub;
  String get vouchersAndOffers;
  String get vouchersSub;
  String get settingsAndUtilities;
  String get pushNotifications;
  String get notificationsSub;
  String get accountSecurity;
  String get securitySub;
  String get secure;
  String get displayLanguage;
  String get currentLanguageName;
  String get selectLanguage;
  String get english;
  String get vietnamese;
  String get infoAndSupport;
  String get customerSupport;
  String get hotlineSub;
  String get termsAndPolicies;
  String get termsSub;
  String get appVersion;
  String get signOut;
  String get signOutConfirm;
  String get signedOutSuccessfully;

  // -------------------------------------------------------------
  // Admin Hub & Products Management
  // -------------------------------------------------------------
  String get adminDashboard;
  String get adminProductsTitle;
  String get adminProductsSubtitle;
  String get addProduct;
  String get editProduct;
  String deleteProductConfirm(String name);
  String get deleteProductWarning;
  String get productConflictError;
  String get productName;
  String get productPrice;
  String get productCategory;
  String get productDescription;
  String get productImageUrl;
  String get isAvailable;

  // -------------------------------------------------------------
  // Auth & Clerk Sync
  // -------------------------------------------------------------
  String get welcomeToCocoloco;
  String get signInSubtitleModal;
  String get continueWithGoogle;
  String get orWithEmail;
  String get enterEmailAddress;
  String get sendOtpCode;
  String get guestCheckoutPrompt;
  String get guestCheckoutSubtext;
  String get guestBenefitTracking;
  String get guestBenefitRewards;
  String get guestBenefitReceipt;
  String get maybeLater;
  String get syncingWithBackend;
  String get signedInSuccessfully;
  String get syncFailed;

  // -------------------------------------------------------------
  // Theme Modes
  // -------------------------------------------------------------
  String get themeModeTitle;
  String get themeLight;
  String get themeDark;
  String get themeSystem;
  String get themeLightSubtitle;
  String get themeDarkSubtitle;
  String get themeSystemSubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'vi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(_getTranslation(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;

  AppLocalizations _getTranslation(Locale locale) {
    switch (locale.languageCode) {
      case 'vi':
        return AppLocalizationsVi();
      case 'en':
      default:
        return AppLocalizationsEn();
    }
  }
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
