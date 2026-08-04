import 'exercise_model.dart';

class WorkoutModel {
  final String id;
  final String title;
  final String description;
  final String category; // strength | cardio | hiit | yoga | flexibility
  final String difficulty; // beginner | intermediate | advanced
  final int estimatedMinutes;
  final List<ExerciseModel> exercises;
  final String? imageUrl;
  final bool isAiGenerated;
  final DateTime? completedAt;
  final DateTime createdAt;

  const WorkoutModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.exercises,
    this.imageUrl,
    this.isAiGenerated = false,
    this.completedAt,
    required this.createdAt,
  });

  bool get isCompleted => completedAt != null;

  int get totalSets => exercises.fold(0, (sum, e) => sum + e.sets);

  factory WorkoutModel.fromJson(Map<String, dynamic> json) => WorkoutModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        category: json['category'] as String,
        difficulty: json['difficulty'] as String,
        estimatedMinutes: json['estimatedMinutes'] as int,
        exercises: (json['exercises'] as List<dynamic>)
            .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        imageUrl: json['imageUrl'] as String?,
        isAiGenerated: json['isAiGenerated'] as bool? ?? false,
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'] as String)
            : null,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'difficulty': difficulty,
        'estimatedMinutes': estimatedMinutes,
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'imageUrl': imageUrl,
        'isAiGenerated': isAiGenerated,
        'completedAt': completedAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
      };

  WorkoutModel copyWith({DateTime? completedAt}) => WorkoutModel(
        id: id,
        title: title,
        description: description,
        category: category,
        difficulty: difficulty,
        estimatedMinutes: estimatedMinutes,
        exercises: exercises,
        imageUrl: imageUrl,
        isAiGenerated: isAiGenerated,
        completedAt: completedAt ?? this.completedAt,
        createdAt: createdAt,
      );
}
