---
name: flutter-test
description: Generates and runs robust, isolated unit and widget tests for Flutter controllers and presentation layers.
---

# Flutter Testing Skill

Guidelines for testing Cocoloco codebase:

## 1. Unit Tests for Controllers & Notifiers
- Test state transitions: Initial -> Loading -> Success / Error.
- Mock Repositories using `mocktail` or fake implementations.
- Verify that exceptions trigger expected error states without crashing.

## 2. Widget Tests for Screens
- Wrap widgets with `ProviderScope` containing overridden providers.
- Use `tester.pumpAndSettle()`.
- Assert expected text, buttons, and state renderings.

## 3. Execution Commands:
```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/controllers/cart_controller_test.dart

# Run with coverage
flutter test --coverage
```
