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

## Gameplay Rules
- Daily task XP limit: 50 XP/day for user-created tasks; quests remain unlimited. Profile fields: `daily_task_xp_limit` (int, default 50), `task_xp_earned_today` (int), `task_xp_reset_date` (date). Midnight reset uses client local date.
- Late task penalties (tasks with due dates): 1 day late -10%, 2 days -20%, 3 days -30%, 4 days -40%, 5+ days -50% cap. Penalty applies before the daily cap; tasks without due dates are never penalized.
- Partial awards: if remaining daily allowance is lower than task XP, award the remainder (no wasted effort). Feedback shows awarded XP and daily progress (e.g., 30/50).
- Admin adjustments: limits stored per user; adjust `daily_task_xp_limit` as needed for specific users.

## Quest Lifecycle
- Schema: quests have `expiration_date` (optional) and `is_retired` (bool, default false). Indexes on both fields improve filtering.
- Admin create/edit: add quest modal allows optional expiration date; edit modal adds expiration editor and a red "Retired" toggle to hide quests without deleting. Clear buttons remove expiration.
- Student view filtering: home quest list filters to active, non-retired quests and only those with no expiration or a future expiration date; expired/retired quests are hidden and redemption errors explain expired/retired status.
- SQL migration: see `QUEST_EXPIRATION_SQL.md` for Supabase alters, indexes, and trigger updates that enforce expiration/retirement during code redemption.

## Troubleshooting
- "Unable to load asset: AssetManifest.json": run `flutter clean` and rebuild.
- White screen on load: dark backgrounds are set; check for failing network resources.
- iOS Pod issues: run `pod repo update` then `pod install`.

## Repository Hygiene
- Keep large media in `assets/` and avoid committing secrets.
- Use Issues and Pull Requests with clear titles and templates.
