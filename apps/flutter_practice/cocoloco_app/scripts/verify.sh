#!/bin/bash
set -e

echo "🔍 [Cocoloco Quality Gate] Running static analysis..."
flutter analyze

echo "🧪 [Cocoloco Quality Gate] Running unit and widget tests..."
flutter test

echo "✅ [Cocoloco Quality Gate] All checks passed cleanly!"
