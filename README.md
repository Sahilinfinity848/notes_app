# Flutter Notes App

A simple and user-friendly Notes application built using Flutter and Dart. It allows users to create, edit, delete, and search notes while keeping their data saved locally on their device.

## Features

- Create new notes with a title and description.
- Edit existing notes.
- Delete notes with confirmation.
- Search notes by title.
- Save notes locally using SharedPreferences.
- Light and Dark themes.
- Display note details and dates.
- Retain notes and theme preferences after restarting the app.

## Technologies Used

- Flutter
- Dart
- SharedPreferences
- Android
- Visual Studio Code

## Project Structure

```text
lib/
├── models/
│   └── note.dart
├── screens/
│   ├── home_screen.dart
│   └── add_edit_note_screen.dart
├── services/
│   ├── storage_service.dart
│   └── theme_service.dart
├── widgets/
│   └── note_card.dart
└── main.dart
```

## Prerequisites

- Flutter SDK
- Dart SDK
- Android phone or emulator
- Visual Studio Code

## How to Run

1. Clone this repository.
2. Open the project folder in VS Code.
3. Install dependencies:

```bash
flutter pub get
```

4. Connect an Android phone with USB debugging enabled, or start an emulator.
5. Check connected devices:

```bash
flutter devices
```

6. Run the application:

```bash
flutter run
```

## Build APK

To generate a release APK:

```bash
flutter build apk --release
```

APK location:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Screenshots

Add screenshots of the following app screens:

- Home screen displaying notes
- Add/Edit Note screen
- Search functionality
- Dark theme

Place the images inside a `screenshots/` folder and link them here.

## Data Storage

The application uses SharedPreferences to store notes locally in JSON format. Theme preferences are also saved locally.

## Author

Developed as a Flutter Notes App project.