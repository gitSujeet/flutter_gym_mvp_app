# AI Fitness App 🏋️

An AI-powered fitness and gym companion built with Flutter, Firebase, and Gemini AI.

![Flutter](https://img.shields.io/badge/Flutter-3.3+-02569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-flutter--gym--mvp--app-FFCA28?logo=firebase)
![Dart](https://img.shields.io/badge/Dart-3.3+-0175C2?logo=dart)

---

## Features

- 🤖 **AI Coach** — Chat with Gemini 2.0 Flash for personalized fitness advice
- 📋 **AI Plan Generator** — Generate custom workout and meal plans via AI
- 💪 **Workout Tracker** — Browse, start, and log workouts with a built-in timer
- 🥗 **Nutrition Logger** — Log meals and track daily macros/calories in Firestore
- 📊 **Progress Charts** — Visualize weight history with fl_chart
- 🔐 **Firebase Auth** — Email/password and Google sign-in

---

## Screenshots

> Coming soon

---

## Tech Stack

| Layer | Technology |
|---|---|
| UI | Flutter + Material 3 |
| State Management | Riverpod |
| Navigation | GoRouter |
| AI | Gemini 2.0 Flash via Firebase AI Logic |
| Auth | Firebase Auth + Google Sign-In |
| Database | Cloud Firestore |
| Local Storage | Hive + SharedPreferences |
| Charts | fl_chart |
| Networking | Dio |
| Architecture | Clean Architecture |

---

## Documentation

| Document | Description |
|---|---|
| [Architecture](docs/ARCHITECTURE.md) | High-level system design and data flow |
| [Low Level Design](docs/LOW_LEVEL_DESIGN.md) | Detailed technical design, schemas, providers |
| [API Docs](docs/API_DOCS.md) | Repository contracts, Firestore schema, AI config |
| [Setup Guide](docs/SETUP_GUIDE.md) | Full setup instructions from scratch |
| [Changelog](docs/CHANGELOG.md) | Version history and release notes |

---

## Quick Start

```bash
# 1. Clone
git clone https://github.com/your-username/ai_fitness_app.git
cd ai_fitness_app

# 2. Install dependencies
flutter pub get

# 3. Configure Firebase (see Setup Guide)
flutterfire configure

# 4. Generate Hive adapters
dart run build_runner build --delete-conflicting-outputs

# 5. Run
flutter run
```

See the full [Setup Guide](docs/SETUP_GUIDE.md) for Firebase, Firestore, and AI Logic configuration.

---

## Project Structure

```
lib/
├── core/         # Constants, theme, router, utils, error handling
├── data/         # Models, repositories, Firestore & AI data sources
├── presentation/ # Riverpod providers, screens, widgets
└── shared/       # Reusable widgets and services
docs/
├── ARCHITECTURE.md
├── LOW_LEVEL_DESIGN.md
├── API_DOCS.md
├── SETUP_GUIDE.md
└── CHANGELOG.md
```

---

## Firebase Project

- **Project:** flutter-gym-mvp-app
- **Android:** com.sujeet.ai_fitness_app
- **iOS:** com.sujeet.aiFitnessApp

---

## License

MIT © 2026 Sujeet Kumar
