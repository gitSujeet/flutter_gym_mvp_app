# High Level Architecture — AI Fitness App

## Overview

AI Fitness App is a Flutter mobile application that uses Clean Architecture principles,
Firebase as the backend, and Google's Gemini AI (via Firebase AI Logic) as the AI engine.

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                    │
│                                                         │
│   Screens          Providers (Riverpod)    Widgets      │
│   ────────         ────────────────────    ───────      │
│   SplashScreen     authProvider            CustomButton │
│   HomeScreen       workoutProvider         ChatBubble   │
│   AiChatScreen     nutritionProvider       ProgressRing │
│   WorkoutScreen    aiProvider              MacroChart   │
│   NutritionScreen  currentUserProvider     BottomNavBar │
│   ProgressScreen                                        │
│   ProfileScreen                                         │
└────────────────────────────┬────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                        │
│                                                         │
│   Entities             Use Cases                        │
│   ────────             ─────────                        │
│   User                 SignInUseCase                    │
│   Workout              SignUpUseCase                    │
│   Exercise             GetWorkoutsUseCase               │
│   Meal                 LogWorkoutUseCase                │
│                        GetMealPlanUseCase               │
│                        GetAiResponseUseCase             │
└────────────────────────────┬────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────┐
│                       DATA LAYER                         │
│                                                         │
│   Repositories         Models          Data Sources     │
│   ─────────────        ──────          ────────────     │
│   AuthRepository       UserModel       FirebaseAuth     │
│   AiRepository         WorkoutModel    Firestore        │
│   WorkoutRepo          MealModel       FirebaseAI       │
│   NutritionRepo        ExerciseModel   Hive (local)     │
│                        AiRecModel      SharedPrefs      │
└────────────────────────────┬────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────┐
│                    FIREBASE BACKEND                      │
│                                                         │
│   Firebase Auth    Firestore DB    Firebase AI Logic    │
│   ─────────────    ────────────    ─────────────────    │
│   Email/Password   users/          Gemini 2.0 Flash     │
│   Google Sign-In   workouts/       Chat completions     │
│                    meals/          Workout plans        │
│                    progress/       Meal plans           │
└─────────────────────────────────────────────────────────┘
```

---

## Layer Responsibilities

### Presentation Layer
- **Screens** — UI widgets, no business logic
- **Providers (Riverpod)** — state management, bridges UI and data layer
- **Shared Widgets** — reusable UI components

### Domain Layer
- **Entities** — pure Dart classes, no framework dependencies
- **Use Cases** — single-responsibility business logic operations
- **Repository Interfaces** — contracts the data layer must implement

### Data Layer
- **Repositories** — implement domain contracts, orchestrate data sources
- **Models** — data classes with JSON serialization and Hive adapters
- **Remote Data Sources** — Firebase Auth, Firestore, Firebase AI Logic
- **Local Data Sources** — Hive (structured data), SharedPreferences (settings)

---

## Key Design Decisions

| Decision | Choice | Reason |
|---|---|---|
| State Management | Riverpod | Compile-safe, testable, no BuildContext dependency |
| Navigation | GoRouter | Declarative, deep-link support, URL-based routing |
| AI Integration | Firebase AI Logic | Works with new AQ. key format, secure proxy, no key in app |
| Local Storage | Hive | Fast, type-safe, NoSQL for offline caching |
| Architecture | Clean Architecture | Separation of concerns, testability, scalability |
| Auth | Firebase Auth | Email + Google sign-in, handles token refresh |
| Database | Cloud Firestore | Real-time, scalable, offline support built-in |

---

## Data Flow

```
User Action
    │
    ▼
Screen (Widget)
    │ calls
    ▼
Riverpod Provider / Notifier
    │ calls
    ▼
Repository
    │ calls
    ▼
Remote/Local Data Source
    │ returns
    ▼
Model (parsed data)
    │ mapped to
    ▼
Entity / State update
    │ triggers
    ▼
UI rebuild
```

---

## Firebase Project

- **Project ID:** flutter-gym-mvp-app
- **Android Package:** com.sujeet.ai_fitness_app
- **iOS Bundle ID:** com.sujeet.aiFitnessApp
- **Services Used:** Authentication, Firestore, Firebase AI Logic
