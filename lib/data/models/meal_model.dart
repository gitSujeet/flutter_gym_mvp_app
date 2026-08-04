class MealModel {
  final String id;
  final String name;
  final String mealType; // breakfast | lunch | dinner | snack
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double servingSize;
  final String servingUnit;
  final DateTime loggedAt;

  const MealModel({
    required this.id,
    required this.name,
    required this.mealType,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.servingSize,
    required this.servingUnit,
    required this.loggedAt,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) => MealModel(
        id: json['id'] as String,
        name: json['name'] as String,
        mealType: json['mealType'] as String,
        calories: (json['calories'] as num).toDouble(),
        proteinG: (json['proteinG'] as num).toDouble(),
        carbsG: (json['carbsG'] as num).toDouble(),
        fatG: (json['fatG'] as num).toDouble(),
        servingSize: (json['servingSize'] as num).toDouble(),
        servingUnit: json['servingUnit'] as String,
        loggedAt: DateTime.parse(json['loggedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mealType': mealType,
        'calories': calories,
        'proteinG': proteinG,
        'carbsG': carbsG,
        'fatG': fatG,
        'servingSize': servingSize,
        'servingUnit': servingUnit,
        'loggedAt': loggedAt.toIso8601String(),
      };
}
