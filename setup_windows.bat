@echo off
setlocal
cd /d "%~dp0"
where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter was not found. Add the Flutter SDK bin folder to PATH and reopen this terminal.
  pause
  exit /b 1
)
rem Flutter creates Android scaffolding compatible with your installed SDK.
rem Existing lib/main.dart, pubspec.yaml, and tests are kept without --overwrite.
call flutter create --platforms=android,web --project-name panelverse --no-pub .
if errorlevel 1 exit /b 1
call flutter pub get
if errorlevel 1 exit /b 1
echo.
echo Setup complete. Run flutter run to launch the project.
pause
