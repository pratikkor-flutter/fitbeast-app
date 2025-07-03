import 'package:hive/hive.dart';

part 'fitness_goal_enum.g.dart';

@HiveType(typeId: 5)
enum FitnessGoal {
  @HiveField(0)
  weightLoss,
  @HiveField(1)
  muscleGain,
  @HiveField(2)
  maintenance,
}

extension FitnessGoalLabel on FitnessGoal {
  String get label {
    switch (this) {
      case FitnessGoal.weightLoss:
        return "Weight Loss";
      case FitnessGoal.muscleGain:
        return "Muscle Gain";
      case FitnessGoal.maintenance:
        return "Weight Maintenance";
    }
  }
}
