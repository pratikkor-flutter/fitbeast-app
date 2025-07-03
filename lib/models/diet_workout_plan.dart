import 'package:hive/hive.dart';

part 'diet_workout_plan.g.dart';

@HiveType(typeId: 6)
class DietWorkoutPlan extends HiveObject {
  @HiveField(0)
  final String clusterKey;

  @HiveField(1)
  final Map<String, DayMeals> dietPlan;

  @HiveField(2)
  final List<String> workoutPlan;

  @HiveField(3)
  final String createdAt;

  DietWorkoutPlan({
    required this.clusterKey,
    required this.dietPlan,
    required this.workoutPlan,
    required this.createdAt 
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dietPlanJson = {};
    dietPlan.forEach((day, meals) {
      dietPlanJson[day] = meals.toJson();
    });

    return {
      'cluster_key': clusterKey,
      'diet_plan': dietPlanJson,
      'workout_plan': workoutPlan,
      'createdAt': createdAt,
    };
  }

  factory DietWorkoutPlan.fromJson(Map<String, dynamic> json) {
    final Map<String, DayMeals> parsedDietPlan = {};
    (json['diet_plan'] as Map<String, dynamic>).forEach((day, mealsData) {
      parsedDietPlan[day] = DayMeals.fromJson(mealsData);
    });

    return DietWorkoutPlan(
      clusterKey: json['cluster_key'] as String,
      dietPlan: parsedDietPlan,
      workoutPlan: List<String>.from(json['workout_plan'] as List),
      createdAt: DateTime.now().toLocal().toIso8601String(),
    );
  }
}

@HiveType(typeId: 1)
class DayMeals {
  @HiveField(0)
  final String breakfast;
  
  @HiveField(1)
  final String dinner;
  
  @HiveField(2)
  final String lunch;
  
  @HiveField(3)
  final String snacks;

  DayMeals({
    required this.breakfast,
    required this.dinner,
    required this.lunch,
    required this.snacks,
  });

  Map<String, dynamic> toJson() => {
    'Breakfast': breakfast,
    'Dinner': dinner,
    'Lunch': lunch,
    'Snacks': snacks,
  };

  factory DayMeals.fromJson(Map<String, dynamic> json) => DayMeals(
    breakfast: json['Breakfast'] as String,
    dinner: json['Dinner'] as String,
    lunch: json['Lunch'] as String,
    snacks: json['Snacks'] as String,
  );
}