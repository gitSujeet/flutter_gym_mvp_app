class ExerciseModel {
  final String id;
  final String name;
  final String muscleGroup;
  final String equipment;
  final String difficulty; // beginner | intermediate | advanced
  final String? imageUrl;
  final String? videoUrl;
  final String instructions;
  final int sets;
  final int reps;
  final double? weightKg;
  final int? durationSeconds; // for time-based exercises
  final int restSeconds;

  const ExerciseModel({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.equipment,
    required this.difficulty,
    this.imageUrl,
    this.videoUrl,
    required this.instructions,
    required this.sets,
    required this.reps,
    this.weightKg,
    this.durationSeconds,
    required this.restSeconds,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => ExerciseModel(
        id: json['id'] as String,
        name: json['name'] as String,
        muscleGroup: json['muscleGroup'] as String,
        equipment: json['equipment'] as String,
        difficulty: json['difficulty'] as String,
        imageUrl: json['imageUrl'] as String?,
        videoUrl: json['videoUrl'] as String?,
        instructions: json['instructions'] as String,
        sets: json['sets'] as int,
        reps: json['reps'] as int,
        weightKg: (json['weightKg'] as num?)?.toDouble(),
        durationSeconds: json['durationSeconds'] as int?,
        restSeconds: json['restSeconds'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'muscleGroup': muscleGroup,
        'equipment': equipment,
        'difficulty': difficulty,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'instructions': instructions,
        'sets': sets,
        'reps': reps,
        'weightKg': weightKg,
        'durationSeconds': durationSeconds,
        'restSeconds': restSeconds,
      };
}
