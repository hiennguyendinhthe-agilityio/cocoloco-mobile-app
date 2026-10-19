Execute the `release-checklist` skill to audit this repository for release readiness.

Perform the following steps:
1. Verify version and build number in `pubspec.yaml`.
2. Run static analysis via `flutter analyze` and confirm 0 issues.
3. Run the automated test suite via `flutter test`.
4. Scan for forbidden debug prints or sensitive test credentials.
5. Output a structured Release Readiness Assessment table with pass/fail status for each gate.
