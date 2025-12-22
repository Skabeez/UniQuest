# UniQuest — Admin Guide

This guide covers deployment, configuration, and operations for UniQuest.

## Prerequisites
- Flutter SDK (stable channel)
- Firebase project (Hosting, Crashlytics optional)
- Supabase project for Auth + Data
- macOS + Xcode for iOS builds; Windows/macOS/Linux for Android/Web

## Configuration
- Assets: All images referenced are under `assets/images/`. Keep filenames consistent with code.
- Supabase: Configure keys/env in your runtime (FlutterFlow manages most setup); ensure email confirmation is enabled.
- Firebase Hosting: `firebase/firebase.json` currently targets `public`. Flutter builds output `build/web`.
  - Option A: set `hosting.public` to `build/web`.
  - Option B: copy build outputs into `public` before `firebase deploy`.

## Build & Deploy
### Web
```bash
flutter clean
flutter pub get
flutter build web
# Option A: deploy from build/web by updating hosting.public
firebase deploy --only hosting
# Option B: copy build into public
robocopy build\web public /MIR
firebase deploy --only hosting
```

### Android
```bash
flutter clean
flutter pub get
flutter build apk --release
```
Upload the APK or build an App Bundle (`flutter build appbundle`) for Play Store.

### iOS (requires macOS)
```bash
flutter clean
flutter pub get
cd ios
pod install
open Runner.xcworkspace  # in Xcode
# Set Team, bundle ID, then:
flutter build ios --release
```
Archive and export IPA via Xcode.

## Operations
- Crashlytics: ensure Firebase Crashlytics is enabled in your Firebase project.
- Asset updates: add images to `assets/images/` and keep `pubspec.yaml` assets section intact.
- Environment: avoid hardcoding secrets; use secure storage or platform configs.

## Troubleshooting
- "Unable to load asset: AssetManifest.json": run `flutter clean` and rebuild.
- White screen on load: dark backgrounds are set; check for failing network resources.
- iOS Pod issues: run `pod repo update` then `pod install`.

## Repository Hygiene
- Keep large media in `assets/` and avoid committing secrets.
- Use Issues and Pull Requests with clear titles and templates.
