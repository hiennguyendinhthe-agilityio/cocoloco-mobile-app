import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cocoloco_app/core/theme/app_colors.dart';
import 'package:cocoloco_app/models/cart_item.dart';
import 'package:cocoloco_app/models/product.dart';

void main() {
  group('CartItem Model Tests', () {
    const testProduct = Product(
      id: 'prod-123',
      name: 'Cold Brew',
      price: 4.5,
      category: 'coffee',
      description: 'Slow-steeped cold brew',
      priceDisplay: '\$4.50',
      imageAsset: 'assets/images/cold_brew.png',
      titleColor: Colors.black,
    );

    test('Initializes with valid properties and calculates totalPrice', () {
      const item = CartItem(
        id: 'c1',
        productId: 'prod-123',
        name: 'Cold Brew',
        quantity: 3,
        price: 4.5,
        customization: 'Oat Milk',
        titleColor: AppColors.primary,
        product: testProduct,
      );

      expect(item.id, 'c1');
      expect(item.productId, 'prod-123');
      expect(item.name, 'Cold Brew');
      expect(item.quantity, 3);
      expect(item.price, 4.5);
      expect(item.customization, 'Oat Milk');
      expect(item.titleColor, AppColors.primary);
      expect(item.product, testProduct);
      expect(item.totalPrice, 13.5);
    });

    test('Throws AssertionError when quantity is less than 1', () {
      expect(
        () => CartItem(
          id: 'c2',
          productId: 'prod-123',
          name: 'Cold Brew',
          quantity: 0,
          price: 4.5,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('copyWith updates specified fields while keeping other fields unchanged', () {
      const original = CartItem(
        id: 'c1',
        productId: 'prod-123',
        name: 'Cold Brew',
        quantity: 2,
        price: 4.5,
        customization: 'Standard',
      );

      final updated = original.copyWith(
        quantity: 5,
        price: 5.0,
        customization: 'Almond Milk',
        name: 'Cold Brew Large',
        id: 'c2',
        productId: 'prod-456',
        titleColor: Colors.red,
        product: testProduct,
      );

      expect(updated.id, 'c2');
      expect(updated.productId, 'prod-456');
      expect(updated.name, 'Cold Brew Large');
      expect(updated.quantity, 5);
      expect(updated.price, 5.0);
      expect(updated.customization, 'Almond Milk');
      expect(updated.titleColor, Colors.red);
      expect(updated.product, testProduct);
      expect(updated.totalPrice, 25.0);

      // copyWith with no args returns equivalent item
      final identicalCopy = original.copyWith();
      expect(identicalCopy, equals(original));
    });

    test('Equality operator and hashCode work correctly', () {
      const itemA = CartItem(
        id: 'c1',
        productId: 'p1',
        name: 'Espresso',
        quantity: 2,
        price: 3.0,
      );

      const itemB = CartItem(
        id: 'c1',
        productId: 'p1',
        name: 'Espresso (Renamed)', // name not compared in ==
        quantity: 2,
        price: 3.0,
      );

      const itemDifferentQty = CartItem(
        id: 'c1',
        productId: 'p1',
        name: 'Espresso',
        quantity: 3,
        price: 3.0,
      );

      expect(itemA, equals(itemB));
      expect(itemA.hashCode, equals(itemB.hashCode));
      expect(itemA, isNot(equals(itemDifferentQty)));
    });
  });
}
