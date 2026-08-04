class AiRecommendationModel {
  final String id;
  final String type; // workout_plan | meal_plan | coaching_tip
  final String content;
  final Map<String, dynamic>? structuredData;
  final DateTime generatedAt;

  const AiRecommendationModel({
    required this.id,
    required this.type,
    required this.content,
    this.structuredData,
    required this.generatedAt,
  });

  factory AiRecommendationModel.fromJson(Map<String, dynamic> json) =>
      AiRecommendationModel(
        id: json['id'] as String,
        type: json['type'] as String,
        content: json['content'] as String,
        structuredData: json['structuredData'] as Map<String, dynamic>?,
        generatedAt: DateTime.parse(json['generatedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'content': content,
        'structuredData': structuredData,
        'generatedAt': generatedAt.toIso8601String(),
      };
}

class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}
