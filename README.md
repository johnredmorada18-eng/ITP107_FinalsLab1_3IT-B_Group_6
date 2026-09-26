# PanelVerse Flutter project

A dark manga and manhwa design for ITP107 Finals Laboratory 1. It includes
Login, Sign-Up, and Home, a bundled original illustrated background, matching
coral accents, and named-route navigation. No third-party Dart packages are used.

## Run on Windows

1. Extract this ZIP and open its `panelverse` folder in VS Code or Android Studio.
2. Open a terminal in that folder (the one containing `pubspec.yaml`).
3. Run the following commands:

```sh
flutter create --platforms=android,web --project-name panelverse --no-pub .
flutter pub get
flutter run
```

The first command generates native Android files for your installed Flutter SDK.
Existing app code, assets, pubspec, and tests are preserved; do not add
`--overwrite`. You can instead double-click `setup_windows.bat` for the first two
commands. On macOS/Linux, run `sh setup.sh`.

Start an Android emulator or attach a device before `flutter run`. To preview
in Chrome, run `flutter run -d chrome`. The included `web` folder also allows
Chrome use directly after `flutter pub get`.

Requires Flutter 3.22 or newer, with Dart 3.4 or newer. The Flutter SDK is not
included. If the terminal says Flutter is not recognized, add your Flutter
installation's `bin` directory to PATH, close the terminal, and open a new one.

## Try the required flow

1. On Login, tap **Create an account**.
2. Enter your full name, a valid email, and matching passwords (6+ characters).
3. Tap **Sign up**. Home welcomes you using that exact full name.
4. Tap **Log out**. The app returns to Login.
5. Also try **Back to login** on Sign-Up.

For direct Login, use any nonempty email/username and any password of at least
six characters, for example `reader` and `reader123`.

This project demonstrates UI and navigation. It does not create real accounts,
verify credentials, save passwords, or persist profiles. Direct Login uses the
username (or the part of the email before `@`) as its display name. Sign-Up
passes the full name directly to Home via route arguments.

## Files

| Path | Purpose |
| --- | --- |
| `lib/main.dart` | Entire app: routes, theme, three screens, and reusable widgets |
| `pubspec.yaml` | Flutter dependencies and background asset registration |
| `assets/images/manga_background.png` | Bundled original manga/manhwa artwork |
| `web/` | Browser entry point |
| `test/widget_test.dart` | Navigation, route arguments, logout, and validation tests |
| `setup_windows.bat` / `setup.sh` | Generate Android scaffolding and resolve dependencies |
| `SUBMISSION_CHECKLIST.md` | Required screenshots, group roles, and naming instructions |
| `ARTWORK.md` | Artwork origin, path, and prompt |

All screens are in one Dart file so you can easily copy the implementation into
an existing Flutter project. In that case, copy the image as well and add its
asset path to your existing `flutter: assets:` section. If the package is renamed,
update the package import in `test/widget_test.dart`.

## Navigation and lab requirements

| Requirement | Implementation |
| --- | --- |
| Named routes | `MaterialApp.routes`: `/`, `/signup`, `/home` |
| Login fields | Email/username and password, with validation |
| Login to Home | `Navigator.pushNamedAndRemoveUntil` |
| Login to Sign-Up | `Navigator.pushNamed` |
| Sign-Up fields | Full name, email, password, confirm password |
| Sign-Up to Home | `Navigator.pushNamedAndRemoveUntil`, with `HomeArguments(name)` |
| Name on Home | Read with `ModalRoute.of(context)?.settings.arguments` |
| Sign-Up back to Login | `Navigator.pop` (replacement fallback if no previous route exists) |
| Logout | Clear navigation history and open Login |
| Consistent design | Shared background, colors, fields, panels, buttons, and typography |

The app clears authentication screens on entry to Home, and clears Home on
logout. Back therefore cannot reopen a discarded authentication or Home screen.
Forms scroll on smaller displays and while the keyboard is open.

## Check before submission

```sh
dart format lib test
flutter analyze
flutter test
flutter run
```

The project source, asset paths, and archive contents were checked during
preparation. Flutter/Dart are not installed in the preparation environment, so
the app has not been compiled, emulator-tested, or visually verified in Flutter;
the included widget tests have not been executed there. Run the commands above
on your computer and capture actual screenshots for submission.

## Customization

- Change `coral`, `ink`, `panel`, and `paper` at the top of `lib/main.dart`.
- To use a different manga/manhwa background, replace
  `assets/images/manga_background.png` with your own PNG of the same filename.
- Restart the app after changing assets or `pubspec.yaml`.
- Update the group information and ZIP filename before submitting.

## Flutter references

- [Named routes](https://docs.flutter.dev/cookbook/navigation/named-routes)
- [Route arguments](https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments)
- [Clearing the navigation stack](https://api.flutter.dev/flutter/widgets/Navigator/pushNamedAndRemoveUntil.html)
- [Bundling image assets](https://docs.flutter.dev/ui/assets/assets-and-images)
