<img src="assets/logo_agility.jpg">

# ☕ Cocoloco - Artisanal Coffee & Bakery Mobile App

[![Flutter](https://img.shields.io/badge/Flutter-3.27%2B-02569B.svg?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.6%2B-0175C2.svg?logo=dart&logoColor=white)](https://dart.dev)
[![State Management](https://img.shields.io/badge/State-Flutter%20Riverpod%202.6-blue.svg)](https://riverpod.dev)
[![Network](https://img.shields.io/badge/HTTP-Dio%205.7%20%2B%20Interceptors-blueviolet.svg)](https://pub.dev/packages/dio)
[![Tests](https://img.shields.io/badge/Tests-197%20Passed%20(100%25)-success.svg)](https://flutter.dev/docs/testing)
[![Code Quality](https://img.shields.io/badge/Analyze-0%20Issues-brightgreen.svg)](https://flutter.dev/docs/testing/code-quality)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A high-performance, enterprise-grade mobile application built with **Flutter 3.27+**, **Dart 3.6+**, and **Riverpod 2.6+** following **Clean Architecture** principles. Developed at **AgilityIO**, Cocoloco powers the next-generation ordering experience for artisanal coffee, fresh morning bakery, and gourmet culinary items.

Backed by an asynchronous **FastAPI (Python 3.12)** backend with **PostgreSQL 16** and **Clerk RS256 JWKS** authentication.

---

## 📱 User Experience & Visual Showcase

- **Artisanal Luxury Brand Aesthetics**: Curated color palette combining Deep Espresso (`#260D11`), Rich Burgundy (`#3E0F15`), and Honey Amber (`#FFA000`) with sleek Dark & Warm Light themes.
- **Choreographed Animated Splash Screen**:
  - Elastic scale bounce (`Curves.easeOutBack`) and amber halo glow pulse.
  - Staggered typography slide-ins for *COCOLOCO* and *ARTISANAL COFFEE & BAKERY*.
  - Background catalog pre-warming eliminates skeleton loading latency on the browse screen.
- **Artisanal 3D App Icon**: Custom high-resolution vector emblem featuring a golden coffee bean and tropical coconut silhouette across Android mipmaps and Web platforms.
- **Sticky Sliver Header & Catalog Discovery**: Slivers-powered browsing with dynamic category pills (Coffee, Bakery, Breakfast, Drink), live keyword search, and animated product cards.
- **Interactive Product Detail & Steppers**: Custom item quantity controllers, dynamic category notes, and hero image animations.
- **Cart & Order Lifecycle Management**:
  - Floating and persistent Cart sheet with item quantity increments, real-time total updates, and optimistic checkout.
  - Customer order tracking with active status badges (Pending, Brewing, Completed, Cancelled).
  - Customer soft-hide functionality allowing users to dismiss fulfilled orders from their personal view without mutating database history.
- **Role-Based Admin Hub**:
  - In-app store management with 2-Tier RBAC.
  - Full product CRUD with multipart image upload.
  - Instant order status transitions with shift-view dismissal.
- **Dynamic Internationalization (i18n)**: Seamless English (`en`) and Vietnamese (`vi`) language switching on the fly.

---

## 🏗️ Architecture & Project Structure

The project strictly adheres to **Clean Architecture** and feature-first modularity:

```
apps/flutter_practice/cocoloco_app/
├── assets/
│   ├── fonts/               # Custom branding typography (Chap, Inter)
│   ├── icons/               # High-res launcher icons & vector assets
│   ├── images/              # Artisanal photography & brand assets
│   └── logo_agility.jpg     # AgilityIO corporate emblem
├── lib/
│   ├── core/
│   │   ├── constants/       # Mock data & business defaults
│   │   ├── errors/          # AppException & RFC 7807 Problem Details
│   │   ├── localization/    # AppLocalizations, English & Vietnamese dictionaries
│   │   ├── network/         # Dio ApiClient, ErrorInterceptor, Token headers
│   │   ├── providers/       # Global theme mode & network providers
│   │   ├── services/        # SessionService (SharedPreferences auth persistence)
│   │   └── theme/           # AppTheme, Tokens, AppPalette, Semantics
│   ├── data/
│   │   ├── providers/       # Riverpod StateNotifiers (Products, Cart, Orders)
│   │   └── repositories/   # Abstract & Concrete Repositories (Product, Order)
│   ├── models/              # Immutable Data Models (Product, Order, CartItem, User)
│   ├── screens/             # Screen pages (Splash, Browse, Detail, Cart, Orders, Admin, Profile)
│   └── widgets/             # Reusable UI components & modals
├── test/                    # 100% isolated unit & widget test suite (25 test files)
└── pubspec.yaml             # Flutter configuration & dependencies
```

---

## ⚡ Tech Stack & Libraries

| Category | Technology | Version | Purpose |
|---|---|---|---|
| **Framework** | Flutter | `3.27+` | Multi-platform declarative UI framework |
| **Language** | Dart | `3.6+` | Strongly-typed object-oriented language |
| **State Management** | Riverpod | `^2.6.1` | Compile-safe reactive state dependency injection |
| **Networking** | Dio | `^5.7.0` | HTTP client with interceptors & form-data support |
| **Storage** | SharedPreferences | `^2.3.5` | Secure local token & session persistence |
| **Image Picker** | image_picker | `^1.1.2` | Native camera & gallery image capture |
| **Localization** | flutter_localizations | SDK | Dynamic language switching (EN / VI) |
| **Testing** | flutter_test | SDK | Unit, model, repository, and widget test coverage |

---

## 🧪 Quality Gate & Automated Testing

The project maintains an industry-standard test suite ensuring zero regressions:

```bash
# Navigate to the Cocoloco App directory
cd apps/flutter_practice/cocoloco_app

# Run static analysis and linting
flutter analyze

# Run the complete test suite (197 tests)
flutter test
```

### Verified Test Metrics:
- **Total Test Cases**: `197 passed (100%)`
- **Lint Issues**: `0 issues`
- **Execution Speed**: `< 25s`
- **Coverage**: Includes unit tests for models, repositories, Riverpod state transitions, and interactive widget tests for all user journeys.

---

## 🚀 Getting Started

### 1. Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.22.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.4.0`)
- Android Studio / Xcode for emulators or physical device debugging
- Running Cocoloco FastAPI backend on `http://127.0.0.1:8000` (optional, falls back to rich mock data)

### 2. Installation
```bash
# Clone the repository
git clone https://github.com/hiennguyendinhthe-agilityio/cocoloco-mobile-app.git
cd cocoloco-mobile-app/apps/flutter_practice/cocoloco_app

# Install Flutter dependencies
flutter pub get

# Run on connected device or emulator
flutter run
```

---

## 📄 Corporate Attribution & License

Developed with passion by **AgilityIO Engineering Team**.  
Licensed under the [MIT License](LICENSE).
