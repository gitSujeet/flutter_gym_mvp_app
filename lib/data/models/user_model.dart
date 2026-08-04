import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? photoUrl;

  @HiveField(4)
  final double? weightKg;

  @HiveField(5)
  final double? heightCm;

  @HiveField(6)
  final int? age;

  @HiveField(7)
  final String? fitnessGoal; // lose_weight | build_muscle | endurance | stay_healthy

  @HiveField(8)
  final String? activityLevel; // sedentary | light | moderate | active | very_active

  @HiveField(9)
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.weightKg,
    this.heightCm,
    this.age,
    this.fitnessGoal,
    this.activityLevel,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        photoUrl: json['photoUrl'] as String?,
        weightKg: (json['weightKg'] as num?)?.toDouble(),
        heightCm: (json['heightCm'] as num?)?.toDouble(),
        age: json['age'] as int?,
        fitnessGoal: json['fitnessGoal'] as String?,
        activityLevel: json['activityLevel'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'weightKg': weightKg,
        'heightCm': heightCm,
        'age': age,
        'fitnessGoal': fitnessGoal,
        'activityLevel': activityLevel,
        'createdAt': createdAt.toIso8601String(),
      };

  UserModel copyWith({
    String? name,
    String? photoUrl,
    double? weightKg,
    double? heightCm,
    int? age,
    String? fitnessGoal,
    String? activityLevel,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        email: email,
        photoUrl: photoUrl ?? this.photoUrl,
        weightKg: weightKg ?? this.weightKg,
        heightCm: heightCm ?? this.heightCm,
        age: age ?? this.age,
        fitnessGoal: fitnessGoal ?? this.fitnessGoal,
        activityLevel: activityLevel ?? this.activityLevel,
        createdAt: createdAt,
      );
}
