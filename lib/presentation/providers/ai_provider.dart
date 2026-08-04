import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/datasources/remote/ai_remote_ds.dart';
import '../../data/models/ai_recommendation_model.dart';
import '../../data/repositories/ai_repository.dart';

final aiRemoteDataSourceProvider = Provider<AiRemoteDataSource>(
  (ref) => AiRemoteDataSource(),
);

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return AiRepository(
    remoteDataSource: ref.watch(aiRemoteDataSourceProvider),
  );
});

// Chat state
class AiChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const AiChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  AiChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) =>
      AiChatState(
        messages: messages ?? this.messages,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class AiChatNotifier extends StateNotifier<AiChatState> {
  final AiRepository _repo;
  final _uuid = const Uuid();

  AiChatNotifier(this._repo) : super(const AiChatState());

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: _uuid.v4(),
      content: message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    final result = await _repo.sendChatMessage(
      history: state.messages,
      message: message,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (response) {
        final aiMessage = ChatMessage(
          id: _uuid.v4(),
          content: response,
          isUser: false,
          timestamp: DateTime.now(),
        );
        state = state.copyWith(
          messages: [...state.messages, aiMessage],
          isLoading: false,
        );
      },
    );
  }

  void clearChat() => state = const AiChatState();
}

final aiChatProvider =
    StateNotifierProvider<AiChatNotifier, AiChatState>((ref) {
  return AiChatNotifier(ref.watch(aiRepositoryProvider));
});

// AI Plan state
final aiWorkoutPlanProvider = FutureProvider.family<String, Map<String, dynamic>>(
  (ref, params) async {
    final repo = ref.watch(aiRepositoryProvider);
    final result = await repo.generateWorkoutPlan(
      fitnessGoal: params['fitnessGoal'] as String,
      activityLevel: params['activityLevel'] as String,
      daysPerWeek: params['daysPerWeek'] as int,
      equipment: params['equipment'] as String?,
    );
    return result.fold((f) => throw f.message, (plan) => plan);
  },
);

final aiMealPlanProvider = FutureProvider.family<String, Map<String, dynamic>>(
  (ref, params) async {
    final repo = ref.watch(aiRepositoryProvider);
    final result = await repo.generateMealPlan(
      targetCalories: params['targetCalories'] as double,
      fitnessGoal: params['fitnessGoal'] as String,
      dietaryRestrictions: params['dietaryRestrictions'] as List<String>?,
    );
    return result.fold((f) => throw f.message, (plan) => plan);
  },
);
