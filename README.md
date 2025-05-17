# Flutter Items Dashboard

A Flutter web application for displaying and managing items with Firebase Firestore integration.

## Features

- Display items in a responsive grid layout
- Filter items by status
- Search items by title, description, or category
- Firebase Firestore integration using JavaScript interop
- Fallback to mock data if Firebase is unavailable

## Getting Started

### Prerequisites

- Flutter SDK (version 3.7.0 or higher)
- Firebase account and Firestore database setup

### Setup

1. **Clone the repository**

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Download the Inter font files**
   Download the Inter font files from [Google Fonts](https://fonts.google.com/specimen/Inter) and place them in the `fonts` directory:
   - fonts/Inter-Regular.ttf
   - fonts/Inter-Medium.ttf
   - fonts/Inter-SemiBold.ttf
   - fonts/Inter-Bold.ttf

4. **Update Firebase configuration**
   Make sure the Firebase configuration in `web/index.html` matches your Firebase project.

### Running the Application

```bash
flutter run -d chrome
```

## Project Structure

- `lib/main.dart` - Main entry point
- `lib/pages/items_page_figma.dart` - Main items page implementing Figma design
- `lib/models/item_model_fixed.dart` - Item data model
- `lib/services/web_firebase_service_fixed.dart` - Service for interacting with Firebase
- `web/index.html` - Contains Firebase configuration and JavaScript interop functions

## Alternate Implementations

The project contains several alternate implementations:

- `simple_items_app.dart` - Standalone app with mock data
- `firebase_rest_service.dart` - Alternative implementation using REST API
- `firebase_items_page_fixed.dart` - Alternative implementation of items page
