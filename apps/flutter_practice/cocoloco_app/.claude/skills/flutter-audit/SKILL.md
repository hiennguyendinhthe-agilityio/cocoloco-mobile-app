---
name: flutter-audit
description: Audits a Flutter screen, widget, or controller against Cocoloco engineering standards and 7 architectural rules.
---

# Flutter Audit Skill

Use this skill when reviewing existing code or auditing a screen for architectural compliance.

## Audit Checklist:
1. **Presentation Layer Isolation:**
   - Does any widget in `lib/presentation/` perform raw HTTP/Dio calls? (Must be NO).
   - Is business logic (cart calculation, validation, token refresh) embedded in `StatefulWidget.build()` or `setState`? (Must be moved to Controller).
2. **State Management (Riverpod):**
   - Are providers using appropriate lifecycle (`autoDispose` where transient)?
   - Are async states handled with `.when()`, `.whenData()`, or explicit Loading/Error states?
3. **Error Handling & Fallbacks:**
   - Are any try-catch blocks silently swallowing errors without logging or user feedback?
   - Are there any fake fallback values (e.g. defaulting null product to placeholder item)?
4. **Code Quality:**
   - Run `flutter analyze` and ensure 0 warnings/errors.
   - Verify proper `const` constructors on widgets.

## Output Format:
- **Findings Summary:** Table of violations (Severity, File, Line, Issue).
- **Refactoring Recommendation:** Concrete action items before writing code.
