---
name: release-checklist
description: Audits the repository against production release gates. Use when preparing a release, cutting a release branch, generating release notes, or verifying pre-deployment readiness.
allowed-tools: Read, Grep, Glob, Bash(git status *), Bash(flutter analyze), Bash(flutter test)
---

# Mobile App Release Checklist Skill

## Purpose
Enforces comprehensive quality, security, and integrity verification before deploying or merging release candidates into production or release branches for the Cocoloco Mobile App.

---

## 📋 Release Verification Protocol

### Phase 1: Version & Semantic Tagging Audit
1. Inspect `pubspec.yaml`:
   - Verify `version: X.Y.Z+build` adheres to Semantic Versioning (`MAJOR.MINOR.PATCH+BUILD`).
   - Confirm the build number is incremented compared to the previous production release.
2. Check Git status and branch alignment:
   - Ensure working tree is clean (`git status`).
   - Identify latest release tag (`git describe --tags --abbrev=0`).

### Phase 2: Static Analysis Quality Gate
1. Execute `flutter analyze`.
2. **Quality Rule:** Output must report `No issues found!`.
   - Zero errors, zero warnings, zero linter lints.
   - Any deprecations or warnings must be resolved before proceeding.

### Phase 3: Automated Test Suite Execution
1. Execute `flutter test`.
2. **Verification Rule:** 100% of unit, widget, and state tests must pass.
3. Verify critical business domains:
   - Cart subtotal and monetary calculations.
   - Authentication session lifecycle.
   - Order submission payload schemas.

### Phase 4: Production Security & Hygiene Audit
1. Scan for forbidden debugging artifacts:
   - Run `Grep` for raw `print(` statements in `lib/` (use structured logging / logger instead).
   - Check for hardcoded secret tokens, staging API base URLs, or mock credentials.
2. Ensure environment configurations match target release environment (Production vs Staging).

### Phase 5: Release Sign-Off Report Generation
Generate a structured Markdown release summary table containing:
- Target Version & Build Number.
- Git commit range (`<last-tag>..HEAD`).
- Static Analysis status (`Pass / Fail`).
- Automated Test execution count (`Passed / Total`).
- Sign-off approval status for QA Lead and Tech Lead.
