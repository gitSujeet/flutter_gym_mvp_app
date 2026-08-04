# Low Level Design — AI Fitness App

## 1. Project Structure

```
lib/
├── main.dart                         # App entry point, Firebase & Hive init
├── app.dart                          # MaterialApp.router, theme, GoRouter
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart           # Color palette, gradients
│   │   ├── app_strings.dart          # All hardcoded strings
│   │   └── app_dimensions.dart       # Spacing, radius, sizes
│   ├── theme/
│   │   ├── app_theme.dart            # Light/dark ThemeData
│   │   └── text_styles.dart          # Poppins TextTheme
│   ├── router/
│   │   └── app_router.dart           # GoRouter config, all routes
│   ├── utils/
│   │   ├── validators.dart           # Form validation functions
│   │   ├── formatters.dart           # Number/date formatters
│   │   └── extensions.dart           # String, DateTime, Context extensions
│   └── error/
│       ├── failures.dart             # Failure sealed classes
│       └── exceptions.dart           # Custom exceptions
│
├── data/
│   ├── models/
│   │   ├── user_model.dart           # @HiveType, fromJson/toJson
│   │   ├── workout_model.dart        # fromJson/toJson, computed props
│   │   ├── exercise_model.dart       # fromJson/toJson
│   │   ├── meal_model.dart           # fromJson/toJson
│   │   └── ai_recommendation_model.dart  # ChatMessage, AiRecommendation
│   ├── repositories/
│   │   ├── auth_repository.dart      # Firebase Auth operations
│   │   ├── workout_repository.dart   # Workout CRUD
│   │   ├── nutrition_repository.dart # Meal CRUD
│   │   └── ai_repository.dart        # AI chat + plan generation
│   └── datasources/
│       ├── remote/
│       │   ├── api_client.dart       # Dio HTTP client
│       │   ├── firestore_service.dart # Firestore CRUD
│       │   └── ai_remote_ds.dart     # Firebase AI Logic
│       └── local/
│           ├── hive_service.dart     # Hive box management
│           └── prefs_service.dart    # SharedPreferences wrapper
│
├── presentation/
│   ├── providers/
│   │   ├── auth_provider.dart        # AuthNotifier, authStateProvider
│   │   ├── workout_provider.dart     # workoutsProvider, WorkoutNotifier
│   │   ├── nutrition_provider.dart   # mealsProvider, NutritionNotifier
│   │   └── ai_provider.dart          # AiChatNotifier, plan providers
│   └── screens/
│       ├── splash/                   # Animated splash + navigation logic
│       ├── onboarding/               # 3-slide onboarding + goal setup
│       ├── auth/                     # Login + Register forms
│       ├── home/                     # Dashboard with stats
│       ├── workout/                  # List, detail, active workout timer
│       ├── nutrition/                # Macros, meal log
│       ├── ai_coach/                 # Chat UI, plan generator
│       ├── progress/                 # fl_chart weight graph
│       └── profile/                  # User stats, settings
│
└── shared/
    ├── widgets/
    │   ├── custom_button.dart        # Primary + outlined button
    │   ├── custom_text_field.dart    # Labeled input with validation
    │   ├── loading_indicator.dart    # Centered spinner
    │   └── bottom_nav_bar.dart       # 5-tab navigation bar
    └── services/
        └── notification_service.dart # Push notification setup (stub)
```

---

## 2. Data Models

### UserModel
```dart
class UserModel {
  String id           // Firebase UID
  String name
  String email
  String? photoUrl
  double? weightKg
  double? heightCm
  int? age
  String? fitnessGoal   // lose_weight | build_muscle | endurance | stay_healthy
  String? activityLevel // sedentary | light | moderate | active | very_active
  DateTime createdAt
}
```

### WorkoutModel
```dart
class WorkoutModel {
  String id
  String title
  String category        // strength | cardio | hiit | yoga | flexibility
  String difficulty      // beginner | intermediate | advanced
  int estimatedMinutes
  List<ExerciseModel> exercises
  bool isAiGenerated
  DateTime? completedAt  // null = not done
  DateTime createdAt
}
```

### ExerciseModel
```dart
class ExerciseModel {
  String id
  String name
  String muscleGroup
  String equipment
  int sets
  int reps
  double? weightKg
  int? durationSeconds   // for timed exercises
  int restSeconds
}
```

### MealModel
```dart
class MealModel {
  String id
  String name
  String mealType    // breakfast | lunch | dinner | snack
  double calories
  double proteinG
  double carbsG
  double fatG
  DateTime loggedAt
}
```

### ChatMessage
```dart
class ChatMessage {
  String id
  String content
  bool isUser
  DateTime timestamp
}
```

---

## 3. Firestore Schema

```
users/
  {uid}/
    id, name, email, photoUrl, weightKg, heightCm,
    age, fitnessGoal, activityLevel, createdAt

    workouts/
      {workoutId}/
        id, title, category, difficulty, estimatedMinutes,
        exercises[], isAiGenerated, completedAt, createdAt

    meals/
      {mealId}/
        id, name, mealType, calories, proteinG,
        carbsG, fatG, servingSize, servingUnit, loggedAt

    progress/
      {docId}/
        type (weight | workout)
        weightKg (if type=weight)
        workoutId (if type=workout)
        date
```

---

## 4. Riverpod Providers

| Provider | Type | Purpose |
|---|---|---|
| `authStateProvider` | StreamProvider | Firebase auth state stream |
| `currentUserProvider` | StateProvider | Cached UserModel |
| `authNotifierProvider` | StateNotifierProvider | Sign in/up/out actions |
| `workoutsProvider` | FutureProvider | Fetch workouts from Firestore |
| `workoutNotifierProvider` | StateNotifierProvider | Complete workout action |
| `todaysMealsProvider` | FutureProvider | Today's meals from Firestore |
| `nutritionNotifierProvider` | StateNotifierProvider | Log/delete meals |
| `dailyCaloriesProvider` | Provider | Computed calorie total |
| `aiChatProvider` | StateNotifierProvider | Chat messages + loading state |
| `aiWorkoutPlanProvider` | FutureProvider.family | Generate AI workout plan |
| `aiMealPlanProvider` | FutureProvider.family | Generate AI meal plan |
| `firestoreServiceProvider` | Provider | FirestoreService singleton |
| `prefsServiceProvider` | FutureProvider | SharedPreferences instance |

---

## 5. Navigation Routes

| Route | Screen | Auth Required |
|---|---|---|
| `/` | SplashScreen | No |
| `/onboarding` | OnboardingScreen | No |
| `/goal-setup` | GoalSetupScreen | No |
| `/login` | LoginScreen | No |
| `/register` | RegisterScreen | No |
| `/home` | HomeScreen | Yes |
| `/workouts` | WorkoutListScreen | Yes |
| `/workouts/:id` | WorkoutDetailScreen | Yes |
| `/workouts/:id/active` | ActiveWorkoutScreen | Yes |
| `/nutrition` | NutritionScreen | Yes |
| `/nutrition/log` | MealLogScreen | Yes |
| `/ai-coach/chat` | AiChatScreen | Yes |
| `/ai-coach/plan` | AiPlanScreen | Yes |
| `/progress` | ProgressScreen | Yes |
| `/profile` | ProfileScreen | Yes |
| `/profile/settings` | SettingsScreen | Yes |

---

## 6. AI Integration Flow

```
User types message
       │
       ▼
AiChatNotifier.sendMessage()
       │
       ▼
AiRepository.sendChatMessage()
       │
       ▼
AiRemoteDataSource.chat()
       │
       ▼
FirebaseAI.googleAI().generativeModel()
       │  (routes via Firebase proxy)
       ▼
Gemini 2.0 Flash API
       │
       ▼
Response text
       │
       ▼
ChatMessage(isUser: false)
       │
       ▼
State update → UI rebuild
```

---

## 7. Authentication Flow

```
App Launch
    │
    ▼
SplashScreen (2s)
    │
    ├── User logged in? ──► HomeScreen
    │
    ├── Onboarded? ──────► LoginScreen
    │
    └── New user? ───────► OnboardingScreen
                               │
                               ▼
                          GoalSetupScreen
                               │
                               ▼
                          RegisterScreen
                               │
                               ▼
                          Firebase Auth
                               │
                               ▼
                          HomeScreen
```

---

## 8. Error Handling Strategy

| Layer | Method |
|---|---|
| Data Sources | try/catch → throw typed Exception |
| Repositories | catch Exception → return `Left(Failure)` via dartz |
| Providers | expose `AsyncValue.error` state |
| Screens | watch for error state, show SnackBar or error widget |

---

## 9. Local Storage Strategy

| Data | Storage | TTL |
|---|---|---|
| Current user profile | Hive | Until logout |
| Auth token | SharedPreferences | Until logout |
| Onboarding status | SharedPreferences | Permanent |
| Workout cache | Hive | Session |
| Theme preference | SharedPreferences | Permanent |
