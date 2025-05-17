# Project Cleanup Guide

## Files to Keep:
- lib/main.dart (updated with Figma design)
- lib/models/item_model_fixed.dart
- lib/pages/items_page_figma.dart
- lib/services/web_firebase_service_fixed.dart
- web/index.html
- pubspec.yaml

## Files that can be removed:
- lib/main_clean.dart (redundant)
- lib/main_fixed.dart (redundant)
- lib/main_new.dart (redundant)
- lib/simple_items_app.dart (redundant, replaced by items_page_figma.dart)
- lib/models/item_model_alt.dart (redundant)
- lib/models/item_model.dart (fixed version is better)
- lib/models/item_web.dart (redundant)
- lib/pages/firebase_items_page.dart (replaced by items_page_figma.dart)
- lib/pages/firebase_items_page_fixed.dart (replaced by items_page_figma.dart)
- lib/pages/home_page.dart (redundant)
- lib/pages/items_page.dart (replaced by items_page_figma.dart)
- lib/pages/mock_home_page.dart (redundant)
- lib/pages/temp_home_page.dart (redundant)
- lib/services/firebase_rest_service.dart (using JS interop instead)
- lib/services/firebase_service.dart (using JS interop instead)
- lib/services/item_rest_service.dart (redundant)
- lib/services/item_service.dart (redundant)
- lib/services/web_firebase_service_alt.dart (redundant)
- lib/services/web_firebase_service.dart (fixed version is better)

## Fonts:
Download the Inter font files and place them in the fonts/ directory:
- fonts/Inter-Regular.ttf
- fonts/Inter-Medium.ttf
- fonts/Inter-SemiBold.ttf
- fonts/Inter-Bold.ttf

## Running the Application:
```bash
flutter run -d chrome
```
