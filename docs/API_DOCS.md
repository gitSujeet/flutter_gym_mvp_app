# API Documentation — AI Fitness App

## Repository Contracts

---

### AuthRepository

| Method | Parameters | Returns | Description |
|---|---|---|---|
| `signInWithEmail` | email, password | `Either<Failure, UserModel>` | Email/password login |
| `signUpWithEmail` | name, email, password | `Either<Failure, UserModel>` | Create new account |
| `signInWithGoogle` | — | `Either<Failure, UserModel>` | Google OAuth login |
| `signOut` | — | `Future<void>` | Sign out + clear cache |
| `authStateChanges` | — | `Stream<User?>` | Firebase auth stream |
| `getCachedUser` | — | `UserModel?` | Get locally cached user |

---

### AiRepository

| Method | Parameters | Returns | Description |
|---|---|---|---|
| `sendChatMessage` | history, message | `Either<Failure, String>` | Chat with AI coach |
| `generateWorkoutPlan` | fitnessGoal, activityLevel, daysPerWeek, equipment? | `Either<Failure, String>` | Generate AI workout plan |
| `generateMealPlan` | targetCalories, fitnessGoal, restrictions? | `Either<Failure, String>` | Generate AI meal plan |

---

### FirestoreService

| Method | Parameters | Returns | Description |
|---|---|---|---|
| `saveUser` | UserModel | `Future<void>` | Create/update user doc |
| `getUser` | uid | `Future<UserModel?>` | Fetch user profile |
| `getWorkouts` | uid | `Future<List<WorkoutModel>>` | Fetch all workouts |
| `saveWorkout` | uid, WorkoutModel | `Future<void>` | Save workout |
| `logWorkoutComplete` | uid, workoutId | `Future<void>` | Mark workout done |
| `getMealsForDay` | uid, date | `Future<List<MealModel>>` | Get meals for a day |
| `logMeal` | uid, MealModel | `Future<void>` | Log a meal |
| `deleteMeal` | uid, mealId | `Future<void>` | Delete a meal |
| `logBodyWeight` | uid, weightKg | `Future<void>` | Log weight entry |
| `getWeightHistory` | uid | `Future<List<Map>>` | Get weight history |
| `getCompletedWorkoutsCount` | uid | `Future<int>` | Total completed workouts |
| `seedDefaultWorkouts` | uid | `Future<void>` | Add starter workouts |

---

## Failure Types

| Failure | Cause |
|---|---|
| `ServerFailure` | API or Firestore error |
| `NetworkFailure` | No internet connection |
| `AuthFailure` | Firebase Auth error |
| `CacheFailure` | Hive read/write error |
| `AiFailure` | Gemini API error |

---

## Firebase AI Logic — Gemini Models

### Model Used
- **Model:** `gemini-2.0-flash`
- **Provider:** Firebase AI Logic (Gemini Developer API)
- **Access:** Via `FirebaseAI.googleAI().generativeModel()`

### System Instruction
```
You are an expert AI fitness coach. You provide personalized workout plans,
nutrition advice, and motivational coaching. Always be encouraging, specific,
and evidence-based. Format workout plans clearly with sets, reps, and rest times.
```

### Generation Config
| Parameter | Value |
|---|---|
| temperature | 0.7 |
| topK | 40 |
| topP | 0.95 |
| maxOutputTokens | 2048 |

---

## Firestore Security Rules (Recommended)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null
                         && request.auth.uid == userId;

      // Subcollections inherit parent rule
      match /{subcollection}/{docId} {
        allow read, write: if request.auth != null
                           && request.auth.uid == userId;
      }
    }
  }
}
```

---

## Environment Variables

| Variable | Used In | How to Pass |
|---|---|---|
| `GEMINI_API_KEY` | Legacy (no longer used) | `--dart-define` |

> **Note:** Firebase AI Logic no longer requires a `GEMINI_API_KEY` in the app.
> The API is accessed securely via your Firebase project credentials.
