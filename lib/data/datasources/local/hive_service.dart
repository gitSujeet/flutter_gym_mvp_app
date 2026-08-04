import 'package:hive_flutter/hive_flutter.dart';

import '../../models/user_model.dart';

class HiveService {
  static const String _userBoxName = 'user_box';
  static const String _workoutsBoxName = 'workouts_box';
  static const String _mealsBoxName = 'meals_box';

  static Future<void> init() async {
    Hive.registerAdapter(UserModelAdapter());
    await Hive.openBox<UserModel>(_userBoxName);
    await Hive.openBox<Map>(_workoutsBoxName);
    await Hive.openBox<Map>(_mealsBoxName);
  }

  // User
  Box<UserModel> get _userBox => Hive.box<UserModel>(_userBoxName);

  Future<void> saveUser(UserModel user) async {
    await _userBox.put('current_user', user);
  }

  UserModel? getUser() => _userBox.get('current_user');

  Future<void> clearUser() async {
    await _userBox.delete('current_user');
  }

  // Workouts cache
  Box<Map> get _workoutsBox => Hive.box<Map>(_workoutsBoxName);

  Future<void> saveWorkouts(List<Map<String, dynamic>> workouts) async {
    await _workoutsBox.clear();
    for (var i = 0; i < workouts.length; i++) {
      await _workoutsBox.put(i, workouts[i]);
    }
  }

  List<Map<String, dynamic>> getWorkouts() {
    return _workoutsBox.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  // Meals cache
  Box<Map> get _mealsBox => Hive.box<Map>(_mealsBoxName);

  Future<void> saveMeals(List<Map<String, dynamic>> meals) async {
    await _mealsBox.clear();
    for (var i = 0; i < meals.length; i++) {
      await _mealsBox.put(i, meals[i]);
    }
  }

  List<Map<String, dynamic>> getMeals() {
    return _mealsBox.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }
}
