import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../datasources/remote/ai_remote_ds.dart';
import '../models/ai_recommendation_model.dart';

class AiRepository {
  final AiRemoteDataSource _remoteDataSource;

  AiRepository({required AiRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Future<Either<Failure, String>> sendChatMessage({
    required List<ChatMessage> history,
    required String message,
  }) async {
    try {
      final response = await _remoteDataSource.chat(history, message);
      return Right(response);
    } catch (e) {
      return Left(AiFailure('AI coach is unavailable: ${e.toString()}'));
    }
  }

  Future<Either<Failure, String>> generateWorkoutPlan({
    required String fitnessGoal,
    required String activityLevel,
    required int daysPerWeek,
    String? equipment,
  }) async {
    try {
      final plan = await _remoteDataSource.generateWorkoutPlan(
        fitnessGoal: fitnessGoal,
        activityLevel: activityLevel,
        daysPerWeek: daysPerWeek,
        equipment: equipment,
      );
      return Right(plan);
    } catch (e) {
      return Left(AiFailure('Failed to generate workout plan: ${e.toString()}'));
    }
  }

  Future<Either<Failure, String>> generateMealPlan({
    required double targetCalories,
    required String fitnessGoal,
    List<String>? dietaryRestrictions,
  }) async {
    try {
      final plan = await _remoteDataSource.generateMealPlan(
        targetCalories: targetCalories,
        fitnessGoal: fitnessGoal,
        dietaryRestrictions: dietaryRestrictions,
      );
      return Right(plan);
    } catch (e) {
      return Left(AiFailure('Failed to generate meal plan: ${e.toString()}'));
    }
  }
}
