import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/onboarding/goal_setup_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/workout/workout_list_screen.dart';
import '../../presentation/screens/workout/workout_detail_screen.dart';
import '../../presentation/screens/workout/active_workout_screen.dart';
import '../../presentation/screens/nutrition/nutrition_screen.dart';
import '../../presentation/screens/nutrition/meal_log_screen.dart';
import '../../presentation/screens/ai_coach/ai_chat_screen.dart';
import '../../presentation/screens/ai_coach/ai_plan_screen.dart';
import '../../presentation/screens/progress/progress_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/profile/settings_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String goalSetup = '/goal-setup';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String workouts = '/workouts';
  static const String workoutDetail = '/workouts/:id';
  static const String activeWorkout = '/workouts/:id/active';
  static const String nutrition = '/nutrition';
  static const String mealLog = '/nutrition/log';
  static const String aiChat = '/ai-coach/chat';
  static const String aiPlan = '/ai-coach/plan';
  static const String progress = '/progress';
  static const String profile = '/profile';
  static const String settings = '/settings';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.goalSetup,
        builder: (context, state) => const GoalSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.workouts,
        builder: (context, state) => const WorkoutListScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return WorkoutDetailScreen(workoutId: id);
            },
            routes: [
              GoRoute(
                path: 'active',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return ActiveWorkoutScreen(workoutId: id);
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.nutrition,
        builder: (context, state) => const NutritionScreen(),
        routes: [
          GoRoute(
            path: 'log',
            builder: (context, state) => const MealLogScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/ai-coach',
        redirect: (context, state) => AppRoutes.aiChat,
      ),
      GoRoute(
        path: AppRoutes.aiChat,
        builder: (context, state) => const AiChatScreen(),
      ),
      GoRoute(
        path: AppRoutes.aiPlan,
        builder: (context, state) => const AiPlanScreen(),
      ),
      GoRoute(
        path: AppRoutes.progress,
        builder: (context, state) => const ProgressScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
});
