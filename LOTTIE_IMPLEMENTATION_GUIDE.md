# Lottie Animation Implementation Guide

## ✅ Completed: Confetti Burst on Task Completion

### What Was Done:
1. **Created** `LottieBurstOverlay` widget in `lib/components/lottie_burst_overlay/`
   - Three display modes: `showAtPosition()`, `showCentered()`, `showFullscreen()`
   - Auto-removes after animation completes
   - Non-blocking overlay that doesn't interfere with UI

2. **Integrated** confetti burst into task completion flow
   - File: `lib/components/menu_task/menu_task_widget.dart`
   - Triggers when user taps "Mark as Done" and confirms
   - Shows centered confetti burst before success dialog

### How It Works:
```dart
// Triggers centered confetti burst
LottieBurstOverlay.showCentered(
  context: context,
  lottieAsset: 'assets/jsons/confetti.lottie',
  size: 400.0,
);
```

---

## 🔥 Fire Animation - For Streaks

### Recommended Placement:
Display fire animation next to streak counter when user has any active streak (≥1 day)

### Implementation Locations:

#### 1. Profile Page (`lib/profile_page/profile_page_widget.dart`)
Around line 562-592 where streak is displayed:

```dart
// Add this near the streak counter
Row(
  children: [
    if (streakProfilesRow?.taskStreak != null && 
        streakProfilesRow!.taskStreak! >= 1)
      Lottie.asset(
        'assets/jsons/fire.lottie',
        width: 40.0,
        height: 40.0,
        fit: BoxFit.contain,
      ),
    Text(
      '${streakProfilesRow?.taskStreak ?? 0} Streak',
      style: TextStyle(...),
    ),
  ],
)
```

#### 2. View Profile Page (`lib/view_profile/view_profile_widget.dart`)
Around line 469-497 where streak badge is shown:

```dart
// Add animated fire background for active streaks
Stack(
  children: [
    if (streakProfilesRow!.taskStreak! >= 1)
      Positioned.fill(
        child: Lottie.asset(
          'assets/jsons/fire.lottie',
          fit: BoxFit.cover,
          opacity: const AlwaysStoppedAnimation(0.3),
        ),
      ),
    // Existing streak badge
    Text('${streakProfilesRow!.taskStreak!} Streak'),
  ],
)
```

#### 3. Home Page Streak Widget (if exists)
Add subtle fire animation as background element for users with any active streak

---

## 🚀 Businessman Rocket Animation

### Recommended Placements:

#### 1. **Onboarding Completion** ⭐ BEST FIT
**File**: `lib/onboarding/onboarding_widget.dart` or `lib/welcomeview/welcomeview_widget.dart`

Show when user completes onboarding walkthrough:

```dart
// After updating onboarding_completed to true
await ProfilesTable().update(
  data: {'onboarding_completed': true},
  matchingRows: (rows) => rows.eqOrNull('id', currentUserUid),
);

// Show rocket animation
if (context.mounted) {
  LottieBurstOverlay.showCentered(
    context: context,
    lottieAsset: 'assets/jsons/businessman_rocket.lottie',
    size: 300.0,
  );
}

context.pushNamed(WelcomeviewWidget.routeName);
```

#### 2. **Achievement Unlocked** ⭐ RECOMMENDED
**File**: `lib/achievements/achievements_widget.dart`

Show when user unlocks a major achievement:

```dart
LottieBurstOverlay.showCentered(
  context: context,
  lottieAsset: 'assets/jsons/businessman_rocket.lottie',
  size: 250.0,
);
```

#### 3. **Mission Completion** (Optional)
**File**: Mission completion logic (if you have missions system)

Show when user completes a difficult or important mission:

```dart
// After completing mission
await MissionsTable().update(
  data: {'status': 'completed'},
  matchingRows: (rows) => rows.eqOrNull('mission_id', missionId),
);

if (context.mounted) {
  LottieBurstOverlay.showFullscreen(
    context: context,
    lottieAsset: 'assets/jsons/businessman_rocket.lottie',
  );
}
```

---

## 🌈 Black Rainbow Cat Animation

### Recommended Placements:

#### 1. **Profile Customization Success**
**File**: `lib/customize_profile/customize_profile_widget.dart`

Show after user successfully changes their avatar, namecard, or border:

```dart
// After updating profile cosmetics
await ProfilesTable().update(
  data: {
    'equipped_namecard': selectedNamecard,
    'equipped_border': selectedBorder,
  },
  matchingRows: (rows) => rows.eqOrNull('id', currentUserUid),
);

// Show cat animation
if (context.mounted) {
  LottieBurstOverlay.showAtPosition(
    context: context,
    position: Offset(
      MediaQuery.of(context).size.width / 2,
      MediaQuery.of(context).size.height * 0.3,
    ),
    lottieAsset: 'assets/jsons/black_rainbow_cat.lottie',
    size: 200.0,
  );
}
```

#### 2. **Cosmetics Unlock**
**File**: `lib/cosmetics_list/cosmetics_list_widget.dart` (if exists)

Show when user unlocks new cosmetic item:

```dart
// After unlocking cosmetic
LottieBurstOverlay.showCentered(
  context: context,
  lottieAsset: 'assets/jsons/black_rainbow_cat.lottie',
  size: 250.0,
);
```

#### 3. **Easter Egg / Random Delight**
Add to loading page or home page as occasional random animation:

```dart
// Random chance (5%) to show cat when opening home page
if (Random().nextInt(100) < 5) {
  Future.delayed(Duration(milliseconds: 500), () {
    LottieBurstOverlay.showAtPosition(
      context: context,
      position: Offset(100, 200),
      lottieAsset: 'assets/jsons/black_rainbow_cat.lottie',
      size: 150.0,
    );
  });
}
```

---

## 📝 Quick Reference

### Available Lottie Files:
- `assets/jsons/confetti.lottie` - ✅ Integrated (task completion)
- `assets/jsons/fire.lottie` - Suggested for streaks
- `assets/jsons/businessman_rocket.lottie` - Suggested for level up / achievements
- `assets/jsons/black_rainbow_cat.lottie` - Suggested for profile customization

### Overlay Methods:

```dart
// Centered on screen
LottieBurstOverlay.showCentered(
  context: context,
  lottieAsset: 'path/to/animation.lottie',
  size: 300.0,
);

// At specific position
LottieBurstOverlay.showAtPosition(
  context: context,
  position: Offset(x, y),
  lottieAsset: 'path/to/animation.lottie',
  size: 200.0,
);

// Fullscreen
LottieBurstOverlay.showFullscreen(
  context: context,
  lottieAsset: 'path/to/animation.lottie',
);
```

### Tips:
- Animations auto-remove after 2.5 seconds
- Use `context.mounted` check before showing overlay
- Adjust `size` parameter based on animation importance
- For subtle effects, wrap Lottie in `Opacity` widget with value 0.3-0.5
- Test animations in release build for optimal performance

---

## 🚀 Next Steps:

1. Test the confetti burst by completing a task
2. Implement fire animation for streaks in profile pages
3. Add businessman_rocket to level up and onboarding completion
4. Add black_rainbow_cat to profile customization success
5. Consider adding random cat appearances as easter eggs

All animations are optimized `.lottie` files (90% smaller than JSON) for fast loading!
