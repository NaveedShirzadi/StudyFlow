# StudyFlow

StudyFlow is a Flutter app that helps college students plan their work and stay focused. It brings assignments, a calendar, AI help, and focus tools into one place.

Built by a team of four. See the Contributors list on this repository's page.

## Features

- **Accounts.** Sign up and log in with an email and password, using Firebase Authentication.
- **Study Board.** Add tasks, check them off, and delete them. Upload a PDF from the board and tap it to get a summary.
- **PDF AI Summarizer.** Reads a PDF you choose and summarizes it with Google's Gemini 2.5 Flash model, through Firebase AI Logic.
- **Calendar.** Day and month views. The AI study planner takes your subjects, the hours you have each day, and the number of days, then builds a study schedule and places it on the calendar. You can also ask it study questions.
- **Canvas.** Connect with your school's Canvas domain and an access token to list your courses and the assignments in each one, with due dates.
- **Study mode.** Focus setup, a timer, a countdown, a lock in screen, a meditation screen, and a quote screen.
- **Theme Mixer.** Choose your own colors in Settings, with a button to reset to the defaults.

## Built with

- Flutter and Dart
- Firebase Authentication and Firebase AI Logic (Gemini)
- The Groq API for the study planner
- `http`, `file_picker`, and `flutter_colorpicker`

Firebase is set up for Android, iOS, macOS, and web. The Windows and Linux folders are the Flutter defaults and are not connected to Firebase.

## Running it

You need the Flutter SDK. Then:

```
flutter pub get
flutter run
```

### Setting up the AI features

- **PDF summaries** need Firebase AI Logic turned on for the Firebase project.
- **The study planner** calls Groq. In `lib/MenuUI/calander_menu_ui.dart`, the `callGroq` function has a placeholder key, `API_KEY_HERE`. Put your own Groq key there on your own computer and never commit it. Create keys at https://console.groq.com.
- **Canvas** needs no setup in the code. You enter your Canvas domain and access token in the app.

The Firebase files in this repository (`firebase_options.dart`, `google-services.json`, and `GoogleService-Info.plist`) hold app settings that are meant to be public. Who can read or write data is controlled by the Firebase project's security rules.

## Project layout

```
lib/
  main.dart             starts Firebase and opens the login page
  firebase_options.dart Firebase settings for each platform
  MenuUI/               login, menus, study board, calendar, Canvas, settings, theme
  study_mode/           timer, countdown, focus setup, lock in, meditation, quote
assets/images/          images used by the app
```
