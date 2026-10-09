import 'package:flutter/material.dart';
import '../app_localizations.dart';

class AppLocalizationsEn extends AppLocalizations {
  const AppLocalizationsEn() : super(const Locale('en'));

  @override
  String get appTitle => 'Cocoloco - Artisanal Coffee & Bakery';

  @override
  String get appTagline => 'Artisanal Coffee & Bakery';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get confirm => 'Confirm';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get done => 'Done';

  @override
  String get retry => 'Retry';

  @override
  String get search => 'Search';

  @override
  String get searchPlaceholder => 'Search coffee, bakery...';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get comingSoonMsg => 'This feature is coming soon!';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get loading => 'Loading...';

  // Navigation
  @override
  String get navHome => 'Home';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navOrders => 'Orders';

  @override
  String get navChat => 'Support';

  @override
  String get navCart => 'Cart';

  // Categories
  @override
  String get categoryAll => 'All';

  @override
  String get categoryCoffee => '☕ Coffee';

  @override
  String get categoryBakery => '🥐 Bakery';

  @override
  String get categoryCombos => '🎁 Combos';

  @override
  String get categorySpecials => '✨ Specials';

  // Product & Browse
  @override
  String get letsGetThisDayGoing => 'Let’s get this day going';

  @override
  String get aprilSpecial => 'April special';

  @override
  String get featuredOffers => 'Featured Offers';

  @override
  String get dailySpecial => 'Daily Special';

  @override
  String get bestSellers => 'Best Sellers';

  @override
  String addedToOrder(String item) => 'Added $item to order';

  @override
  String get outOfStock => 'Out of Stock';

  @override
  String get available => 'Available';

  @override
  String get viewCart => 'View cart';

  @override
  String get addToOrder => 'Add to Order';

  @override
  String get updateCart => 'Update Cart';

  @override
  String get cartUpdated => 'Cart updated';

  @override
  String get orderNow => 'Order Now';

  @override
  String get noProductsFound => 'No items found in this category';

  @override
  String get noProductsSub =>
      'Try selecting another category or clear search query.';

  // Product Detail
  @override
  String get customization => 'Customization';

  @override
  String get size => 'Size';

  @override
  String get regular => 'Regular';

  @override
  String get large => 'Large';

  @override
  String get sweetness => 'Sweetness';

  @override
  String get iceLevel => 'Ice Level';

  @override
  String get milkOption => 'Milk Option';

  @override
  String get reviews => 'Reviews';

  @override
  String get description => 'Description';

  @override
  String get ingredients => 'Ingredients';

  // Cart & Checkout
  @override
  String get cartTitle => 'Your Cart';

  @override
  String get cartEmptyTitle => 'Your cart is empty';

  @override
  String get cartEmptySubtitle =>
      'Explore Cocoloco\'s fresh coffee & bakery menu to get started!';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get deliveryFee => 'Delivery Fee';

  @override
  String get total => 'Total';

  @override
  String get freeDelivery => 'Free';

  @override
  String get checkout => 'Go to checkout';

  @override
  String get checkoutProcessing => 'Processing Order...';

  @override
  String get clearCart => 'Clear Cart';

  @override
  String get clearCartConfirm => 'Are you sure you want to clear your cart?';

  @override
  String get orderFailed =>
      'Could not complete order. Please check your connection.';

  // Order Success
  @override
  String get orderedTitle => 'Ordered!';

  @override
  String get orderedSubtitle => 'Everything will be ready in 3 minutes.';

  @override
  String get okayGotIt => 'Okay, got it!';

  // Orders Screen
  @override
  String get yourOrders => 'Your Orders';

  @override
  String get trackReceipts => 'Track drinks & past receipts';

  @override
  String get allOrders => 'All Orders';

  @override
  String get pending => 'Pending';

  @override
  String get brewing => 'Brewing';

  @override
  String get completed => 'Completed';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get reorder => 'Reorder';

  @override
  String get noOrdersYet => 'No orders yet';

  @override
  String get noOrdersSubtitle =>
      'Your past orders and beverage tracking will show up here.';

  @override
  String get loginToViewOrders => 'Log in to view orders';

  @override
  String get loginPromptSubtitle =>
      'Sign in to access your order history and live brewing updates.';

  @override
  String ordersCount(int count) => '$count orders';

  // Profile & Settings
  @override
  String get cocolocoAccount => 'Cocoloco Account';

  @override
  String get signInPrompt => 'Sign in for rewards';

  @override
  String get signInSubtitle => 'Earn beans, save addresses & track orders';

  @override
  String get signInButton => 'Sign In with Clerk';

  @override
  String get goldMember => 'Cocoloco Gold Member';

  @override
  String get memberId => 'Member ID';

  @override
  String get cocolocoBeans => 'Cocoloco Beans';

  @override
  String get redeemGifts => 'Redeem drinks & pastries';

  @override
  String get ordersAndTransactions => 'Orders & Transactions';

  @override
  String get orderHistory => 'Order History';

  @override
  String get orderHistorySub => 'Track your orders and delivery status';

  @override
  String get savedAddresses => 'Saved Addresses';

  @override
  String get savedAddressesSub =>
      'Manage delivery addresses for coffee & bakery';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get paymentMethodsSub => 'Credit Card, Apple Pay, Cash';

  @override
  String get vouchersAndOffers => 'Vouchers & Offers';

  @override
  String get vouchersSub => 'You have two 20% discount vouchers';

  @override
  String get settingsAndUtilities => 'Settings & Utilities';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get notificationsSub => 'Receive order status updates';

  @override
  String get accountSecurity => 'Account Security';

  @override
  String get securitySub => 'Clerk RS256 JWKS authentication';

  @override
  String get secure => 'Secure';

  @override
  String get displayLanguage => 'Display Language';

  @override
  String get currentLanguageName => 'English';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get vietnamese => 'Vietnamese (Tiếng Việt)';

  @override
  String get infoAndSupport => 'Information & Support';

  @override
  String get customerSupport => 'Customer Support Hotline';

  @override
  String get hotlineSub => 'Hotline 1900 6868 (8:00 - 22:00)';

  @override
  String get termsAndPolicies => 'Terms of Service & Policies';

  @override
  String get termsSub => 'Protecting user rights';

  @override
  String get appVersion => 'App Version';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signOutConfirm => 'Are you sure you want to sign out?';

  @override
  String get signedOutSuccessfully => 'Signed out successfully.';

  // Admin Hub & Products Management
  @override
  String get adminDashboard => 'Admin Dashboard';

  @override
  String get adminProductsTitle => 'Product Management';

  @override
  String get adminProductsSubtitle => 'Manage store menu and availability';

  @override
  String get addProduct => 'Add New Product';

  @override
  String get editProduct => 'Edit Product';

  @override
  String deleteProductConfirm(String name) =>
      'Are you sure you want to delete $name?';

  @override
  String get deleteProductWarning => 'This action cannot be undone.';

  @override
  String get productConflictError =>
      'Cannot delete: this product has existing orders.';

  @override
  String get productName => 'Product Name';

  @override
  String get productPrice => 'Price (\$)';

  @override
  String get productCategory => 'Category';

  @override
  String get productDescription => 'Description';

  @override
  String get productImageUrl => 'Image URL';

  @override
  String get isAvailable => 'Available for Sale';

  // Auth & Clerk Sync
  @override
  String get welcomeToCocoloco => 'Welcome to Cocoloco';

  @override
  String get signInSubtitleModal => 'Artisanal Coffee & Bakery';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get orWithEmail => 'Or continue with email';

  @override
  String get enterEmailAddress => 'Enter your email address';

  @override
  String get sendOtpCode => 'Send Login Code';

  @override
  String get guestCheckoutPrompt => 'Sign in to complete your order';

  @override
  String get guestCheckoutSubtext =>
      'Sign in to track your order in real time, earn reward beans, and save your receipt history.';

  @override
  String get guestBenefitTracking => 'Live brewing & delivery updates';

  @override
  String get guestBenefitRewards => 'Earn member beans & loyalty rewards';

  @override
  String get guestBenefitReceipt => 'Save digital receipts & 1-tap reorder';

  @override
  String get maybeLater => 'Maybe Later';

  @override
  String get syncingWithBackend => 'Syncing with Cocoloco system...';

  @override
  String get signedInSuccessfully => 'Signed in and synced successfully!';

  @override
  String get syncFailed => 'Sync failed. Please try again.';

  // Theme Modes
  @override
  String get themeModeTitle => 'Theme Mode';

  @override
  String get themeLight => 'Light Theme';

  @override
  String get themeDark => 'Dark Theme';

  @override
  String get themeSystem => 'System Default';

  @override
  String get themeLightSubtitle => 'Warm cream & artisanal burgundy';

  @override
  String get themeDarkSubtitle => 'Deep espresso roast & night coffee';

  @override
  String get themeSystemSubtitle => 'Automatically adapts to device appearance';
}
