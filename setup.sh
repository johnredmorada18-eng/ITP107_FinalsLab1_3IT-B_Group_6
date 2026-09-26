#!/usr/bin/env sh
set -eu
cd "$(dirname "$0")"
if ! command -v flutter >/dev/null 2>&1; then
  echo 'Flutter was not found. Add the Flutter SDK bin folder to PATH.'
  exit 1
fi
# Generate platform scaffolding for the installed SDK, preserving existing files.
flutter create --platforms=android,web --project-name panelverse --no-pub .
flutter pub get
echo 'Setup complete. Run flutter run to launch the project.'
