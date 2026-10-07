import '../theme/app_colors.dart';
import '../../models/product.dart';
import '../../models/special_offer.dart';

class MockData {
  /// Backward-compatibility mapping from legacy mock IDs to production PostgreSQL UUIDs
  static const Map<String, String> legacyMockIdMap = {
    'prod_cappuccino': 'f66fe585-6512-45f7-b66f-6bdbe11b146e',
    'prod_crossaint': '87621d48-7a5a-49cc-b1b6-13ff420bf492',
    'prod_artisan_latte': 'c7d6bd66-9f93-4b6b-9cee-a0a1e79c029e',
    'prod_fruit_plate': '3614af77-137a-4307-a86c-52a59c688d57',
  };

  static const List<Product> dailyProducts = [
    Product(
      id: 'f66fe585-6512-45f7-b66f-6bdbe11b146e',
      name: 'Cappuccino',
      priceDisplay: r'$3',
      price: 3.0,
      titleColor: AppColors.cappuccinoPink,
      imageAsset: 'assets/images/cappuccino.jpg',
      description:
          'Caramel Macchiato recipe features rich, dark-roast espresso served with steamed whole or nonfat milk, mixed with sweet caramel syrup, and topped with ribbons of buttery caramel.',
      category: 'Coffee',
      calories: 120,
      rating: 4.9,
    ),
    Product(
      id: '87621d48-7a5a-49cc-b1b6-13ff420bf492',
      name: 'Crossaint',
      priceDisplay: r'$3',
      price: 3.0,
      titleColor: AppColors.croissantBlue,
      imageAsset: 'assets/images/croissant.jpg',
      description:
          'Handcrafted French pastry made with 100% Normandy cultured butter, baked to golden, airy perfection with crisp outer layers.',
      category: 'Bakery',
      calories: 230,
      rating: 4.8,
    ),
    Product(
      id: 'c7d6bd66-9f93-4b6b-9cee-a0a1e79c029e',
      name: 'Artisan Latte',
      priceDisplay: r'$4',
      price: 4.0,
      titleColor: AppColors.americanoOrange,
      imageAsset: 'assets/images/latte_art_pour.jpg',
      description:
          'Double shot of smooth blonde espresso poured over steamed silky oat milk with handcrafted barista rosette.',
      category: 'Coffee',
      calories: 135,
      rating: 4.9,
    ),
    Product(
      id: '3614af77-137a-4307-a86c-52a59c688d57',
      name: 'Fresh Fruits',
      priceDisplay: r'$3.50',
      price: 3.50,
      titleColor: AppColors.matchaGreen,
      imageAsset: 'assets/images/fruit_slices.jpg',
      description:
          'Seasonal sliced grapefruit, pineapples, fresh limes, and organic blueberries served with lavender blossom.',
      category: 'Healthy',
      calories: 95,
      rating: 4.8,
    ),
  ];

  static const List<SpecialOffer> specialOffers = [
    SpecialOffer(
      id: 'offer_breakfast_bundle',
      title: 'BREAKFAST\nBUNDLE',
      subtitle: 'Croissant, Cappuccino & Citrus',
      imageAsset: 'assets/images/breakfast_bundle.jpg',
      price: 8.0,
      priceDisplay: r'$8',
      description:
          'The ultimate morning combination: our freshly baked butter croissant, a velvety cappuccino, and seasonal citrus.',
    ),
    SpecialOffer(
      id: 'offer_fruit_market',
      title: 'APRIL\nHARVEST',
      subtitle: 'Wild Mint & Ripe Apricots',
      imageAsset: 'assets/images/fruit_market.jpg',
      price: 6.0,
      priceDisplay: r'$6',
      description:
          'Freshly picked English market apricots, organic garden mint leaves, and sparkling chilled mineral water.',
    ),
  ];
}
