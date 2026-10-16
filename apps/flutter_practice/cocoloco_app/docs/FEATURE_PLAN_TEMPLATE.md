# 📋 Feature Plan: [FEATURE_NAME]

> **Status:** Draft / In-Progress / In-Review / Completed  
> **Branch:** `feat/[feature-slug]`  
> **Issue/Ticket:** #[ISSUE_NUMBER]

---

## 🎯 1. Requirements Clarification (Post `/grill-me`)
*Summarize key answers from the `/grill-me` requirement interview:*
- **Goal:** [What business value or user need does this solve?]
- **Acceptance Criteria (Given / When / Then):**
  - [ ] Given [Initial condition], When [User does action], Then [Expected result].
  - [ ] Given [Edge case / Error state], When [Failure happens], Then [User sees friendly error].
- **Explicit Non-Goals (Out of Scope):**
  - [What we are NOT doing in this PR].

---

## 🏛️ 2. Architectural Impact & State Boundaries
- **Layer 1 (Presentation):** [What new widgets/screens are added or updated?]
- **Layer 2 (Controller/Notifier):** [What Riverpod provider manages this state?]
- **Layer 3 (Domain/Entity):** [What data models are introduced or modified?]
- **Layer 4 & 5 (Data & API):** [Which endpoints or local storage keys are touched?]

---

## 🔨 3. Implementation Steps (Synced Checkboxes)

- [ ] **Step 1: Data & Domain Layer**
  - [ ] Define immutable model with `freezed` or pure Dart `copyWith`.
  - [ ] Add API client method in DataSource and abstract repository.
- [ ] **Step 2: State Controller Layer**
  - [ ] Implement `AsyncNotifier` in `lib/controllers/`.
  - [ ] Write unit test for initial, loading, and error states.
- [ ] **Step 3: Presentation UI Layer**
  - [ ] Build `ConsumerWidget` adhering to Design System.
  - [ ] Implement explicit Loading skeletonizer and Error retry banner.
- [ ] **Step 4: Quality Gate & Verification**
  - [ ] Run `flutter analyze` (Must pass with 0 errors, 0 warnings).
  - [ ] Run `flutter test` (All tests green).
  - [ ] Manual test in simulator / web preview.

---

## ✅ Definition of Done (DoD)
- [ ] 100% clean `flutter analyze`.
- [ ] Zero regression on existing tests.
- [ ] No `catch (_)` swallowing exceptions without reporting.
- [ ] Tested on target screen sizes.
