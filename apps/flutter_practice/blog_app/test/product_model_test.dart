import 'package:blog_app/core/theme/app_colors.dart';
import 'package:blog_app/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Product Model Tests', () {
    test('fromJson parses complete API payload correctly', () {
      final json = {
        'id': 'prod_001',
        'name': 'Artisan Latte',
        'description': 'Smooth espresso with microfoam',
        'price': '4.50',
        'image_url': 'https://example.com/latte.jpg',
        'category': 'coffee',
        'is_available': true,
      };

      final product = Product.fromJson(json);

      expect(product.id, 'prod_001');
      expect(product.name, 'Artisan Latte');
      expect(product.description, 'Smooth espresso with microfoam');
      expect(product.price, 4.50);
      expect(product.priceDisplay, '\$4.50');
      expect(product.imageUrl, 'https://example.com/latte.jpg');
      expect(product.category, 'Coffee');
      expect(product.isAvailable, true);
      expect(product.titleColor, AppColors.americanoOrange);
    });

    test('fromJson handles null or missing optional fields gracefully', () {
      final json = {
        'id': 'prod_002',
        'name': 'Simple Croissant',
        'price': 3,
        'category': 'pastry',
      };

      final product = Product.fromJson(json);

      expect(product.id, 'prod_002');
      expect(product.name, 'Simple Croissant');
      expect(product.description, '');
      expect(product.price, 3.0);
      expect(product.priceDisplay, '\$3');
      expect(product.imageUrl, isNull);
      expect(product.category, 'Pastry');
      expect(product.isAvailable, true); // default
      expect(product.titleColor, AppColors.croissantBlue);
    });

    test('fromJson assigns correct titleColor based on category', () {
      final coffee = Product.fromJson({'name': 'A', 'category': 'coffee'});
      final pastry = Product.fromJson({'name': 'B', 'category': 'bakery'});
      final seasonal = Product.fromJson({'name': 'C', 'category': 'seasonal'});
      final other = Product.fromJson({'name': 'D', 'category': 'other'});

      expect(coffee.titleColor, AppColors.americanoOrange);
      expect(pastry.titleColor, AppColors.croissantBlue);
      expect(seasonal.titleColor, AppColors.matchaGreen);
      expect(other.titleColor, AppColors.cappuccinoPink);
    });

    test('toJson serializes product attributes correctly', () {
      const product = Product(
        id: 'prod_123',
        name: 'Cold Brew',
        priceDisplay: '\$4',
        price: 4.0,
        titleColor: AppColors.americanoOrange,
        imageAsset: 'assets/images/cappuccino.jpg',
        imageUrl: 'https://example.com/coldbrew.jpg',
        description: 'Steeped for 18 hours',
        category: 'Coffee',
        isAvailable: false,
      );

      final json = product.toJson();

      expect(json['id'], 'prod_123');
      expect(json['name'], 'Cold Brew');
      expect(json['price'], 4.0);
      expect(json['image_url'], 'https://example.com/coldbrew.jpg');
      expect(json['description'], 'Steeped for 18 hours');
      expect(json['category'], 'coffee');
      expect(json['is_available'], false);
    });

    test('copyWith updates properties properly without mutating original', () {
      const original = Product(
        id: 'p1',
        name: 'Original',
        priceDisplay: '\$2',
        price: 2.0,
        titleColor: AppColors.croissantBlue,
        imageAsset: 'asset.jpg',
        description: 'Old desc',
        category: 'Coffee',
        isAvailable: true,
      );

      final updated = original.copyWith(
        name: 'Modified',
        price: 3.5,
        priceDisplay: '\$3.50',
        isAvailable: false,
      );

      expect(updated.id, 'p1');
      expect(updated.name, 'Modified');
      expect(updated.price, 3.5);
      expect(updated.priceDisplay, '\$3.50');
      expect(updated.isAvailable, false);
      expect(updated.description, 'Old desc');

      expect(original.name, 'Original');
      expect(original.isAvailable, true);
    });
  });
}
