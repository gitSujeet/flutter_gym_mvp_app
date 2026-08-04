import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/firestore_service.dart';
import '../../data/models/workout_model.dart';
import 'auth_provider.dart';

final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(),
);

// Fetch workouts from Firestore
final workoutsProvider = FutureProvider<List<WorkoutModel>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final service = ref.read(firestoreServiceProvider);
  // Seed defaults for new users
  await service.seedDefaultWorkouts(user.id);
  return service.getWorkouts(user.id);
});

// Completed workouts count
final completedWorkoutsCountProvider = FutureProvider<int>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return 0;
  return ref.read(firestoreServiceProvider).getCompletedWorkoutsCount(user.id);
});

// Log a completed workout
class WorkoutNotifier extends StateNotifier<AsyncValue<void>> {
  final FirestoreService _service;
  final Ref _ref;

  WorkoutNotifier(this._service, this._ref) : super(const AsyncValue.data(null));

  Future<void> completeWorkout(String workoutId) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return;

    state = const AsyncValue.loading();
    try {
      await _service.logWorkoutComplete(user.id, workoutId);
      // Invalidate so list refreshes
      _ref.invalidate(workoutsProvider);
      _ref.invalidate(completedWorkoutsCountProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final workoutNotifierProvider =
    StateNotifierProvider<WorkoutNotifier, AsyncValue<void>>((ref) {
  return WorkoutNotifier(ref.read(firestoreServiceProvider), ref);
});
