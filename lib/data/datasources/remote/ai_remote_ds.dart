import 'package:firebase_ai/firebase_ai.dart';

import '../../../data/models/ai_recommendation_model.dart';

class AiRemoteDataSource {
  late final GenerativeModel _model;

  AiRemoteDataSource() {
    // Uses Firebase project credentials — no separate API key needed
    _model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.0-flash',
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 2048,
      ),
      systemInstruction: Content.system(
        '''You are an expert AI fitness coach. You provide personalized workout plans, 
        nutrition advice, and motivational coaching. Always be encouraging, specific, 
        and evidence-based. Format workout plans clearly with sets, reps, and rest times.''',
      ),
    );
  }

  Future<String> chat(List<ChatMessage> history, String userMessage) async {
    final contents = [
      ...history.map(
        (msg) => Content(
          msg.isUser ? 'user' : 'model',
          [TextPart(msg.content)],
        ),
      ),
      Content.text(userMessage),
    ];

    final response = await _model.generateContent(contents);
    return response.text ?? 'Sorry, I could not generate a response.';
  }

  Future<String> generateWorkoutPlan({
    required String fitnessGoal,
    required String activityLevel,
    required int daysPerWeek,
    String? equipment,
  }) async {
    final prompt = '''
Generate a $daysPerWeek-day workout plan for someone with the following profile:
- Fitness goal: $fitnessGoal
- Activity level: $activityLevel
- Available equipment: ${equipment ?? 'gym equipment'}

For each day, provide:
1. Workout name and focus
2. Warm-up (5 minutes)
3. Main exercises with sets, reps, and rest time
4. Cool-down (5 minutes)
5. Estimated duration

Format the response clearly with day headers.
''';

    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text ?? 'Could not generate workout plan.';
  }

  Future<String> generateMealPlan({
    required double targetCalories,
    required String fitnessGoal,
    List<String>? dietaryRestrictions,
  }) async {
    final restrictions = dietaryRestrictions?.join(', ') ?? 'none';
    final prompt = '''
Create a one-day meal plan with approximately ${targetCalories.toInt()} calories.
- Fitness goal: $fitnessGoal
- Dietary restrictions: $restrictions

Include breakfast, lunch, dinner, and 2 snacks.
For each meal provide: name, ingredients, macros (protein/carbs/fat), and calories.
''';

    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text ?? 'Could not generate meal plan.';
  }
}
