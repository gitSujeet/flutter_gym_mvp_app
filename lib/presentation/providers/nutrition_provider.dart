import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/datasources/remote/firestore_service.dart';
import '../../data/models/meal_model.dart';
import 'auth_provider.dart';
import 'workout_provider.dart';

// Today's meals
final todaysMealsProvider = FutureProvider<List<MealModel>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return ref
      .read(firestoreServiceProvider)
      .getMealsForDay(user.id, DateTime.now());
});

// Daily calorie totals
final dailyCaloriesProvider = Provider<double>((ref) {
  final meals = ref.watch(todaysMealsProvider).valueOrNull ?? [];
  return meals.fold(0.0, (sum, m) => sum + m.calories);
});

final dailyProteinProvider = Provider<double>((ref) {
  final meals = ref.watch(todaysMealsProvider).valueOrNull ?? [];
  return meals.fold(0.0, (sum, m) => sum + m.proteinG);
});

final dailyCarbsProvider = Provider<double>((ref) {
  final meals = ref.watch(todaysMealsProvider).valueOrNull ?? [];
  return meals.fold(0.0, (sum, m) => sum + m.carbsG);
});

final dailyFatProvider = Provider<double>((ref) {
  final meals = ref.watch(todaysMealsProvider).valueOrNull ?? [];
  return meals.fold(0.0, (sum, m) => sum + m.fatG);
});

// Meal logging
class NutritionNotifier extends StateNotifier<AsyncValue<void>> {
  final FirestoreService _service;
  final Ref _ref;
  final _uuid = const Uuid();

  NutritionNotifier(this._service, this._ref)
      : super(const AsyncValue.data(null));

  Future<bool> logMeal({
    required String name,
    required String mealType,
    required double calories,
    required double proteinG,
    required double carbsG,
    required double fatG,
    double servingSize = 1,
    String servingUnit = 'serving',
  }) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return false;

    state = const AsyncValue.loading();
    try {
      final meal = MealModel(
        id: _uuid.v4(),
        name: name,
        mealType: mealType,
        calories: calories,
        proteinG: proteinG,
        carbsG: carbsG,
        fatG: fatG,
        servingSize: servingSize,
        servingUnit: servingUnit,
        loggedAt: DateTime.now(),
      );
      await _service.logMeal(user.id, meal);
      _ref.invalidate(todaysMealsProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<void> deleteMeal(String mealId) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return;
    await _service.deleteMeal(user.id, mealId);
    _ref.invalidate(todaysMealsProvider);
  }
}

final nutritionNotifierProvider =
    StateNotifierProvider<NutritionNotifier, AsyncValue<void>>((ref) {
  return NutritionNotifier(ref.read(firestoreServiceProvider), ref);
});
