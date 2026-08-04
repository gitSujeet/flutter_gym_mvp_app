import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/meal_model.dart';
import '../../models/workout_model.dart';
import '../../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── Collections ───────────────────────────────────────────────
  CollectionReference get _users => _db.collection('users');
  CollectionReference _workouts(String uid) =>
      _db.collection('users').doc(uid).collection('workouts');
  CollectionReference _meals(String uid) =>
      _db.collection('users').doc(uid).collection('meals');
  CollectionReference _progress(String uid) =>
      _db.collection('users').doc(uid).collection('progress');

  // ─── User ──────────────────────────────────────────────────────
  Future<void> saveUser(UserModel user) async {
    await _users.doc(user.id).set(user.toJson(), SetOptions(merge: true));
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  // ─── Workouts ──────────────────────────────────────────────────
  Future<List<WorkoutModel>> getWorkouts(String uid) async {
    final snap = await _workouts(uid)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs
        .map((d) => WorkoutModel.fromJson(d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveWorkout(String uid, WorkoutModel workout) async {
    await _workouts(uid).doc(workout.id).set(workout.toJson());
  }

  Future<void> logWorkoutComplete(String uid, String workoutId) async {
    await _workouts(uid).doc(workoutId).update({
      'completedAt': DateTime.now().toIso8601String(),
    });
    // Also log to progress
    await _progress(uid).add({
      'type': 'workout',
      'workoutId': workoutId,
      'date': DateTime.now().toIso8601String(),
    });
  }

  // ─── Meals ─────────────────────────────────────────────────────
  Future<List<MealModel>> getMealsForDay(String uid, DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final snap = await _meals(uid)
        .where('loggedAt',
            isGreaterThanOrEqualTo: start.toIso8601String(),
            isLessThan: end.toIso8601String())
        .orderBy('loggedAt')
        .get();

    return snap.docs
        .map((d) => MealModel.fromJson(d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> logMeal(String uid, MealModel meal) async {
    await _meals(uid).doc(meal.id).set(meal.toJson());
  }

  Future<void> deleteMeal(String uid, String mealId) async {
    await _meals(uid).doc(mealId).delete();
  }

  // ─── Progress / Body Weight ────────────────────────────────────
  Future<void> logBodyWeight(String uid, double weightKg) async {
    await _progress(uid).add({
      'type': 'weight',
      'weightKg': weightKg,
      'date': DateTime.now().toIso8601String(),
    });
    // Update user profile weight
    await _users.doc(uid).update({'weightKg': weightKg});
  }

  Future<List<Map<String, dynamic>>> getWeightHistory(String uid) async {
    final snap = await _progress(uid)
        .where('type', isEqualTo: 'weight')
        .orderBy('date')
        .limitToLast(30)
        .get();
    return snap.docs
        .map((d) => d.data() as Map<String, dynamic>)
        .toList();
  }

  Future<int> getCompletedWorkoutsCount(String uid) async {
    final snap = await _workouts(uid)
        .where('completedAt', isNull: false)
        .count()
        .get();
    return snap.count ?? 0;
  }

  // ─── Seed default workouts for new user ───────────────────────
  Future<void> seedDefaultWorkouts(String uid) async {
    final existing = await _workouts(uid).limit(1).get();
    if (existing.docs.isNotEmpty) return; // already seeded

    final defaultWorkouts = _defaultWorkouts();
    for (final w in defaultWorkouts) {
      await _workouts(uid).doc(w['id']).set(w);
    }
  }

  List<Map<String, dynamic>> _defaultWorkouts() {
    final now = DateTime.now().toIso8601String();
    return [
      {
        'id': 'w1',
        'title': 'Upper Body Strength',
        'description': 'Focus on chest, back, shoulders and arms.',
        'category': 'Strength',
        'difficulty': 'Intermediate',
        'estimatedMinutes': 45,
        'exercises': [
          {'id': 'e1', 'name': 'Bench Press', 'muscleGroup': 'Chest', 'equipment': 'Barbell', 'difficulty': 'intermediate', 'instructions': 'Lie flat, press bar up', 'sets': 3, 'reps': 10, 'restSeconds': 60},
          {'id': 'e2', 'name': 'Pull-ups', 'muscleGroup': 'Back', 'equipment': 'Pull-up Bar', 'difficulty': 'intermediate', 'instructions': 'Hang and pull up', 'sets': 3, 'reps': 8, 'restSeconds': 60},
          {'id': 'e3', 'name': 'Overhead Press', 'muscleGroup': 'Shoulders', 'equipment': 'Dumbbell', 'difficulty': 'intermediate', 'instructions': 'Press overhead', 'sets': 3, 'reps': 10, 'restSeconds': 60},
        ],
        'isAiGenerated': false,
        'createdAt': now,
      },
      {
        'id': 'w2',
        'title': 'Full Body HIIT',
        'description': 'High intensity interval training for fat burn.',
        'category': 'HIIT',
        'difficulty': 'Advanced',
        'estimatedMinutes': 30,
        'exercises': [
          {'id': 'e4', 'name': 'Burpees', 'muscleGroup': 'Full Body', 'equipment': 'None', 'difficulty': 'advanced', 'instructions': 'Drop to push-up then jump', 'sets': 4, 'reps': 15, 'restSeconds': 30},
          {'id': 'e5', 'name': 'Jump Squats', 'muscleGroup': 'Legs', 'equipment': 'None', 'difficulty': 'advanced', 'instructions': 'Squat then explode up', 'sets': 4, 'reps': 20, 'restSeconds': 30},
          {'id': 'e6', 'name': 'Mountain Climbers', 'muscleGroup': 'Core', 'equipment': 'None', 'difficulty': 'intermediate', 'instructions': 'Alternate knees to chest fast', 'sets': 4, 'reps': 30, 'restSeconds': 30},
        ],
        'isAiGenerated': false,
        'createdAt': now,
      },
      {
        'id': 'w3',
        'title': 'Lower Body Focus',
        'description': 'Quads, hamstrings, glutes and calves.',
        'category': 'Strength',
        'difficulty': 'Beginner',
        'estimatedMinutes': 50,
        'exercises': [
          {'id': 'e7', 'name': 'Squats', 'muscleGroup': 'Legs', 'equipment': 'Barbell', 'difficulty': 'beginner', 'instructions': 'Feet shoulder-width, squat down', 'sets': 4, 'reps': 12, 'restSeconds': 90},
          {'id': 'e8', 'name': 'Deadlifts', 'muscleGroup': 'Hamstrings', 'equipment': 'Barbell', 'difficulty': 'intermediate', 'instructions': 'Hinge at hips, keep back straight', 'sets': 3, 'reps': 10, 'restSeconds': 90},
          {'id': 'e9', 'name': 'Lunges', 'muscleGroup': 'Legs', 'equipment': 'Dumbbell', 'difficulty': 'beginner', 'instructions': 'Step forward and lower knee', 'sets': 3, 'reps': 12, 'restSeconds': 60},
        ],
        'isAiGenerated': false,
        'createdAt': now,
      },
    ];
  }
}
