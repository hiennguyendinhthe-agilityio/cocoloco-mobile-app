import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

enum ProductType {
  drink,
  bakery,
  bowl,
  meal,
}

class Product {
  final String id;
  final String name;
  final String priceDisplay;
  final double price;
  final Color titleColor;
  final String imageAsset;
  final String? imageUrl;
  final String description;
  final String category;
  final int calories;
  final double rating;
  final bool isFavorite;
  final bool isAvailable;

  const Product({
    required this.id,
    required this.name,
    required this.priceDisplay,
    required this.price,
    required this.titleColor,
    required this.imageAsset,
    this.imageUrl,
    required this.description,
    required this.category,
    this.calories = 140,
    this.rating = 4.9,
    this.isFavorite = false,
    this.isAvailable = true,
  });

  ProductType get productType {
    final cat = category.toLowerCase();
    final n = name.toLowerCase();

    // 1. Bakery & Pastry
    if (cat.contains('bakery') ||
        cat.contains('pastry') ||
        cat.contains('bread') ||
        n.contains('crossaint') ||
        n.contains('croissant') ||
        n.contains('bread') ||
        n.contains('cookie') ||
        n.contains('cake') ||
        n.contains('muffin') ||
        n.contains('bagel') ||
        n.contains('donut') ||
        n.contains('waffle') ||
        n.contains('pancake') ||
        n.contains('toast')) {
      return ProductType.bakery;
    }

    // 2. Bowls & Healthy Salads
    if (cat.contains('healthy') ||
        cat.contains('fruit') ||
        cat.contains('bowl') ||
        cat.contains('salad') ||
        n.contains('fruit') ||
        n.contains('bowl') ||
        n.contains('salad') ||
        n.contains('yogurt') ||
        n.contains('oatmeal') ||
        n.contains('granola') ||
        n.contains('acai') ||
        n.contains('soup')) {
      return ProductType.bowl;
    }

    // 3. Hot Meals, Savory Dishes, Pasta & Combos
    if (cat.contains('bundle') ||
        cat.contains('combo') ||
        cat.contains('meal') ||
        cat.contains('breakfast') ||
        cat.contains('lunch') ||
        cat.contains('dinner') ||
        cat.contains('food') ||
        n.contains('pasta') ||
        n.contains('tagliatelle') ||
        n.contains('spaghetti') ||
        n.contains('noodle') ||
        n.contains('pizza') ||
        n.contains('bundle') ||
        n.contains('combo') ||
        n.contains('breakfast') ||
        n.contains('sandwich') ||
        n.contains('burger') ||
        n.contains('steak') ||
        n.contains('rice') ||
        n.contains('taco')) {
      return ProductType.meal;
    }

    return ProductType.drink;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String? ?? 'Product';
    final priceNum = double.tryParse(json['price']?.toString() ?? '0') ?? 0.0;
    final category = json['category'] as String? ?? 'Coffee';
    final rawImageUrl = json['image_url'] as String?;

    // Thematic title color based on category
    Color color = AppColors.cappuccinoPink;
    final catLower = category.toLowerCase();
    if (catLower.contains('coffee')) {
      color = AppColors.americanoOrange;
    } else if (catLower.contains('pastry') || catLower.contains('bakery')) {
      color = AppColors.croissantBlue;
    } else if (catLower.contains('seasonal') || catLower.contains('bundle')) {
      color = AppColors.matchaGreen;
    }

    // Default asset fallback if image is loading or offline
    String fallbackAsset = 'assets/images/cappuccino.jpg';
    final nameLower = name.toLowerCase();
    if (nameLower.contains('croissant') || nameLower.contains('pastry')) {
      fallbackAsset = 'assets/images/croissant.jpg';
    } else if (nameLower.contains('latte') || nameLower.contains('art')) {
      fallbackAsset = 'assets/images/latte_art_pour.jpg';
    } else if (nameLower.contains('bundle') || nameLower.contains('breakfast')) {
      fallbackAsset = 'assets/images/breakfast_bundle.jpg';
    } else if (nameLower.contains('fruit') || nameLower.contains('pasta')) {
      fallbackAsset = 'assets/images/fruit_slices.jpg';
    }

    final formattedPrice = priceNum == priceNum.roundToDouble()
        ? '\$${priceNum.toInt()}'
        : '\$${priceNum.toStringAsFixed(2)}';

    return Product(
      id: json['id'] as String? ?? '',
      name: name,
      priceDisplay: formattedPrice,
      price: priceNum,
      titleColor: color,
      imageAsset: fallbackAsset,
      imageUrl: rawImageUrl,
      description: json['description'] as String? ?? '',
      category: category.isNotEmpty
          ? category[0].toUpperCase() + category.substring(1)
          : 'Coffee',
      calories: 140,
      rating: 4.9,
      isFavorite: false,
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }

  Product copyWith({
    String? id,
    String? name,
    String? priceDisplay,
    double? price,
    Color? titleColor,
    String? imageAsset,
    String? imageUrl,
    String? description,
    String? category,
    int? calories,
    double? rating,
    bool? isFavorite,
    bool? isAvailable,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      priceDisplay: priceDisplay ?? this.priceDisplay,
      price: price ?? this.price,
      titleColor: titleColor ?? this.titleColor,
      imageAsset: imageAsset ?? this.imageAsset,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      category: category ?? this.category,
      calories: calories ?? this.calories,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image_url': imageUrl,
      'description': description,
      'category': category.toLowerCase(),
      'is_available': isAvailable,
    };
  }
}
