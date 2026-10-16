# Cocoloco Mobile App (Flutter) — Engineering Map & Governance

> **Project Map for Claude Code:** This document is the single source of truth for architectural boundaries, common workflows, and non-negotiable engineering guardrails.

---

## 📌 1. Tech Stack & Architecture

- **Core Framework:** Flutter 3.24+ | Dart 3.5+
- **State Management & DI:** Riverpod 2.x (`AsyncNotifier`, `Notifier`, `StateNotifierProvider`)
- **Networking & API:** Dio client connecting to Cocoloco FastAPI backend
- **Authentication:** Clerk Authentication SDK + secure local token storage
- **UI & Layout:** Custom Design System (`assets/`, Google Fonts, responsive layout)

### 🏛️ Five-Layer Architectural Boundary
1. **Presentation (`lib/presentation/`):** Pure UI widgets and screens. **Dumb UI only.** Never perform raw network calls or own complex business logic in `StatefulWidget`.
2. **Controllers / Notifiers (`lib/controllers/` or `providers/`):** Handles user interactions, manages state transitions, and invokes domain use cases / repositories.
3. **Domain (`lib/domain/`):** Pure Dart entities and business rules. Free of Flutter framework dependencies and `BuildContext`.
4. **Repositories (`lib/data/repositories/`):** Abstraction layer mediating between local cache and remote network data sources.
5. **Data Sources (`lib/data/datasources/`):** Raw API calls (Dio), local database storage, and JSON serialization.

---

## ⚡ 2. Essential Commands

```bash
# Dependencies & Code Generation
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Code Quality & Health Checks (Must be 100% clean)
flutter analyze
flutter test

# Run application
flutter run -d chrome       # Web preview
flutter run -d macos        # macOS desktop
flutter run                 # Mobile device / simulator
```

---

## 🛡️ 3. Non-Negotiable Guardrails ("Design & Safety Laws")

1. **Zero Warnings Policy:** Every pull request and change must pass `flutter analyze` with **0 errors and 0 warnings**.
2. **No Silent Swallowing of Errors:** Never catch an exception and silently pretend it succeeded. Always handle failure states explicitly (`AsyncValue.error` or UI error banners).
3. **No Fake / Dangerous Fallbacks:** Never substitute missing or invalid business entities with arbitrary valid ones (e.g. defaulting an invalid order item to "Cappuccino"). Fail fast and notify the user.
4. **Business Logic Must Be Unit Testable:** Calculations (cart totals, discount vouchers, delivery fees, payload formatters) must be testable without inflating widgets or mocking `BuildContext`.
5. **Git Safety:** 
   - Never force-push (`git push -f`) to shared branches (`main`, `training-flutter-advance`).
   - Spawn a fresh short-lived feature branch (`feat/<name>`) for each new task.
   - Commit messages must accurately describe the actual `git diff`.

---

## 📚 4. Modular Deep References
For in-depth domain specifications, consult:
- Architecture & Layering: `.agents/rules/01-architecture-separation.md`
- Riverpod & State Management: `.agents/rules/02-riverpod-state-di.md`
- Error Handling & Network Resilience: `.agents/rules/03-error-handling-fallbacks.md`
- Testing & Quality Assurance: `.agents/rules/04-testing-quality-performance.md`
- UI Design System: `.agents/rules/05-ui-design-system.md`
- Git Protocol & Conflict Prevention: `.agents/rules/07-git-workflow.md`
