import 'package:fitbeast/enums/activity_level_enum.dart';
import 'package:fitbeast/enums/fitness_goal_enum.dart';
import 'package:fitbeast/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InitHive {
  Future<void> initHive() async {
    // Initialize Hive
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(BodyMetricsAdapter());
    Hive.registerAdapter(HealthProfileAdapter());
    Hive.registerAdapter(FitnessGoalsAdapter());
    Hive.registerAdapter(ActivityLevelAdapter());
    Hive.registerAdapter(FitnessGoalAdapter());

    // Open boxes
    await Hive.openBox<UserModel>('users');
  }
}
