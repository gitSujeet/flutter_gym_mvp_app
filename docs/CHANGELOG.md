# Changelog

All notable changes to AI Fitness App are documented here.

---

## [1.0.0] — 2026-08-05 (Initial Release)

### Added

#### Core
- Clean Architecture setup (Data → Domain → Presentation)
- Riverpod state management
- GoRouter navigation with 16 routes
- Dark theme with Poppins font and custom color palette
- Firebase initialization with FlutterFire CLI

#### Authentication
- Email/Password sign up and sign in
- Google Sign-In (OAuth)
- Persistent auth state via Firebase Auth streams
- Onboarding flow with goal and fitness level selection

#### Screens
- Animated splash screen with logo
- 3-slide onboarding screen
- Goal setup screen (fitness goal + activity level)
- Login and Register screens with form validation
- Home dashboard with progress ring and quick actions
- Workout list with category filters (Firestore-backed)
- Workout detail screen
- Active workout screen with set timer and rest countdown
- Nutrition screen with macro chart
- Meal logger (saves to Firestore)
- AI Coach chat screen with typing indicator
- AI Plan Generator (workout + meal plans)
- Progress screen with fl_chart weight graph
- Profile screen with body stats
- Settings screen (notifications, units)

#### AI Features
- Gemini 2.0 Flash via Firebase AI Logic
- Real-time chat with AI fitness coach
- AI workout plan generator (customizable goal, level, days)
- AI meal plan generator (calorie target, dietary restrictions)
- Suggestion chips on empty chat state
- Typing indicator animation

#### Data
- Firestore integration (users, workouts, meals, progress)
- Default workout seeding for new users (3 starter workouts)
- Hive local cache for offline user profile
- SharedPreferences for app settings and onboarding state
- Daily macro calculations from logged meals

#### Infrastructure
- Internet permission for Android
- minSdkVersion set to 23 (Firebase Auth requirement)
- google-services.json and firebase_options.dart configured
- build_runner setup for Hive code generation

### Known Issues
- Google Sign-In requires SHA-1/SHA-256 in Firebase Console
- Firebase AI Logic must be manually enabled in Firebase Console
- Progress screen weight chart uses placeholder data until weight logging UI is added
- iOS GoogleService-Info.plist needs to be generated separately on macOS
