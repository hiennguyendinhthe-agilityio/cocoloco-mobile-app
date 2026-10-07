<img src="assets/logo_agility.jpg">

# 🥐 Cocoloco App - Flutter Mobile Client

[![Flutter](https://img.shields.io/badge/Flutter-3.27%2B-02569B.svg?logo=flutter&logoColor=white)](https://flutter.dev)
[![Riverpod](https://img.shields.io/badge/State-Riverpod%202.6-blue.svg)](https://riverpod.dev)
[![Tests](https://img.shields.io/badge/Tests-197%20Passed-success.svg)](https://flutter.dev/docs/testing)
[![Code Quality](https://img.shields.io/badge/Analyze-0%20Issues-brightgreen.svg)](https://flutter.dev/docs/testing/code-quality)

Official Flutter mobile client for the **Cocoloco Artisanal Coffee & Bakery** food ordering platform, developed by **AgilityIO**.

---

## 🌟 Core Modules

### 1. Presentation & Choreographed Motion
- **`SplashScreen`** ([`lib/screens/splash_screen.dart`](lib/screens/splash_screen.dart)): Animated entry sequence with choreographed elastic bounce, amber glow aura, and catalog pre-warming.
- **`BrowseScreen`** ([`lib/screens/browse_screen.dart`](lib/screens/browse_screen.dart)): CustomScrollView with SliverAppBar, search field, category chips, and hero cards.
- **`ProductDetailScreen`** ([`lib/screens/product_detail_screen.dart`](lib/screens/product_detail_screen.dart)): Rich item showcase with category-aware step controls.
- **`CartScreen`** ([`lib/screens/cart_screen.dart`](lib/screens/cart_screen.dart)): Reactive checkout sheet with optimistic item adjustments.
- **`OrdersScreen`** ([`lib/screens/orders_screen.dart`](lib/screens/orders_screen.dart)): Full customer order history with soft-dismiss capability.
- **`AdminProductsScreen`** ([`lib/screens/admin_products_screen.dart`](lib/screens/admin_products_screen.dart)): Store manager hub with live product management and multi-part image uploads.

### 2. State Management & Architecture
- **Riverpod 2.6**: Type-safe declarative state management via `StateNotifierProvider` pattern.
- **`productsProvider`**: Reactive catalog fetching, filtering, pagination, and optimistic CRUD updates.
- **`cartProvider`**: Persistent in-memory cart with quantity aggregation and discount computations.
- **`ordersProvider`**: Dual-mode customer and admin order streams with live status transitions.

### 3. Network & Security
- **Dio Client**: Configured with timeouts, `Authorization` Bearer token injection, and logging.
- **`ErrorInterceptor`**: RFC 7807 Problem Details mapper converting network anomalies into actionable, user-friendly messages.
- **`SessionService`**: Single-source-of-truth token persistence via `SharedPreferences`.

---

## 🧪 Testing Runbook

```bash
# Verify code health
flutter analyze

# Execute full test suite
flutter test
```

Developed by **AgilityIO**.
