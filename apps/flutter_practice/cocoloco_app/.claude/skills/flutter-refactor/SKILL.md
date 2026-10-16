---
name: flutter-refactor
description: Safely refactors bloated Flutter widgets by extracting business logic into Riverpod Notifiers and Repositories while preserving exact UI behavior.
---

# Flutter Refactoring Skill

Follow this strict 4-step workflow when refactoring Flutter code:

## Step 1: Baseline Verification
1. Run `flutter analyze` and `flutter test` before touching any code.
2. Verify existing behavior and ensure tests pass.

## Step 2: Extract State & Controller
1. Identify `setState` and logic in the widget.
2. Create an `AsyncNotifier` or `Notifier` in `lib/controllers/` or `lib/providers/`.
3. Move business validation, API calls, and calculations into the controller.

## Step 3: Simplify Widget to ConsumerWidget
1. Convert `StatefulWidget` to `ConsumerWidget` (or `ConsumerStatefulWidget` only if local animation controller / scroll controller requires ticker provider).
2. Replace local state variables with `ref.watch(yourProvider)`.
3. Dispatch user actions via `ref.read(yourProvider.notifier).someAction()`.

## Step 4: Verification & Regression Check
1. Re-run `flutter analyze` (must be 0 errors, 0 warnings).
2. Run `flutter test` to ensure zero regression.
