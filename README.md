# UniQuest

Mobile‑first campus companion built with Flutter. Includes onboarding, a rich campus map with tappable pins, missions, tasks, achievements, and a modern dark UI.

## Getting Started

FlutterFlow projects are built to run on the Flutter _stable_ release.

### Highlights
- Email auth via Supabase
- Campus map with photos and info cards
- Smooth page transitions and walkthroughs
- Dark backgrounds to prevent white flashes

### Docs
- User Guide: docs/user-guide.md
- Admin Guide: docs/admin-guide.md
- Contributing: docs/contributing.md

### Setup
```bash
flutter clean
flutter pub get
flutter analyze
```

### Run
```bash
flutter run -d android
flutter run -d ios     # macOS/Xcode required
flutter run -d chrome
```

### Build
```bash
flutter build web
flutter build apk --release
```
