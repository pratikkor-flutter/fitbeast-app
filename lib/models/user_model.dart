import 'package:fitbeast/enums/activity_level_enum.dart';
import 'package:fitbeast/enums/fitness_goal_enum.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String uid;
  @HiveField(1)
  bool onboardingComplete;
  @HiveField(2)
  BodyMetrics bodyMetrics;
  @HiveField(3)
  HealthProfile healthProfile;
  @HiveField(4)
  FitnessGoals fitnessGoals;
  @HiveField(5)
  DateTime lastUpdated;
  @HiveField(6)
  String name;
  @HiveField(7)
  String username;
  @HiveField(8)
  String email;
  @HiveField(9)
  int streak;
  @HiveField(10)
  List<String> achievements;
  @HiveField(11)
  double caloriesIntake;
  @HiveField(12)
  double caloriesTarget;
  @HiveField(13)
  double caloriesBurned;
  @HiveField(14)
  double caloriesBurnTarget;
  @HiveField(15)
  double waterIntake;
  @HiveField(16)
  double waterTarget;
  @HiveField(17)
  int waterFrequency;
  @HiveField(18)
  int waterFreqTarget;
  @HiveField(19)
  int sleepHours;
  @HiveField(20)
  int sleepTarget;
  @HiveField(21)
  String sleepQuality;
  @HiveField(22)
  DateTime logValidityDate;

  UserModel({
    required this.uid,
    required this.onboardingComplete,
    required this.bodyMetrics,
    required this.healthProfile,
    required this.fitnessGoals,
    required this.lastUpdated,
    required this.name,
    required this.username,
    required this.email,
    required this.streak,
    required this.achievements,
    required this.caloriesIntake,
    required this.caloriesTarget,
    required this.caloriesBurned,
    required this.caloriesBurnTarget,
    required this.waterIntake,
    required this.waterTarget,
    required this.waterFrequency,
    required this.waterFreqTarget,
    required this.sleepHours,
    required this.sleepTarget,
    required this.sleepQuality,
    required this.logValidityDate,
  });
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'username': username,
        'email': email,
        'onboardingComplete': onboardingComplete,
        'bodyMetrics': bodyMetrics.toJson(),
        'healthProfile': healthProfile.toJson(),
        'fitnessGoals': fitnessGoals.toJson(),
        'lastUpdated': lastUpdated.toIso8601String(),
        'streak': streak,
        'achievements': achievements,
        'caloriesIntake': caloriesIntake,
        'caloriesTarget': caloriesTarget,
        'caloriesBurned': caloriesBurned,
        'caloriesBurnTarget': caloriesBurnTarget,
        'waterIntake': waterIntake,
        'waterTarget': waterTarget,
        'waterFrequency': waterFrequency,
        'waterFreqTarget': waterFreqTarget,
        'sleepHours': sleepHours,
        'sleepTarget': sleepTarget,
        'sleepQuality': sleepQuality,
        'logValidityDate': logValidityDate.toIso8601String(),
      };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['uid'],
        name: json['name'] ?? 'beast',
        username: json['username'] ?? '',
        email: json['email'] ?? '',
        onboardingComplete: json['onboardingComplete'] ?? false,
        bodyMetrics: BodyMetricsJson.fromJson(json['bodyMetrics'] ?? {}),
        healthProfile: HealthProfileJson.fromJson(json['healthProfile'] ?? {}),
        fitnessGoals: FitnessGoalsJson.fromJson(json['fitnessGoals'] ?? {}),
        lastUpdated:
            DateTime.tryParse(json['lastUpdated'] ?? '') ?? DateTime.now(),
        streak: json['streak'] ?? 0,
        achievements: List<String>.from(json['achievements'] ?? []),
        caloriesIntake: (json['caloriesIntake'] ?? 0).toDouble(),
        caloriesTarget: (json['caloriesTarget'] ?? 0).toDouble(),
        caloriesBurned: (json['caloriesBurned'] ?? 0).toDouble(),
        caloriesBurnTarget: (json['caloriesBurnTarget'] ?? 0).toDouble(),
        waterIntake: (json['waterIntake'] ?? 0),
        waterTarget: (json['waterTarget'] ?? 0),
        waterFrequency: (json['waterFrequency'] ?? 0),
        waterFreqTarget: (json['waterFreqTarget'] ?? 0),
        sleepHours: (json['sleepHours'] ?? 0),
        sleepTarget: (json['sleepTarget'] ?? 0),
        sleepQuality: json['sleepQuality'] ?? '',
        logValidityDate:
            DateTime.tryParse(json['logValidityDate'] ?? '') ?? DateTime.now(),
      );
}

@HiveType(typeId: 1)
class BodyMetrics {
  @HiveField(0)
  double? height;
  @HiveField(1)
  double? weight;
  @HiveField(2)
  double? goalWeight;
  @HiveField(3)
  double? bodyFat;
  @HiveField(4)
  int? age;
  @HiveField(5)
  String? gender;

  BodyMetrics({
    required this.height,
    required this.weight,
    required this.age,
    required this.gender,
    required this.goalWeight,
    required this.bodyFat,
  });
}

extension BodyMetricsJson on BodyMetrics {
  Map<String, dynamic> toJson() => {
        'height': height,
        'weight': weight,
        'age': age,
        'gender': gender,
        'goalWeight': goalWeight,
        'bodyFat': bodyFat,
      };

  static BodyMetrics fromJson(Map<String, dynamic> json) => BodyMetrics(
        height: (json['height'] as num?)?.toDouble(),
        weight: (json['weight'] as num?)?.toDouble(),
        age: (json['age'] as num?)?.toInt(),
        gender: (json['gender'] as String?),
        goalWeight: (json['goalWeight'] as num?)?.toDouble(),
        bodyFat: (json['bodyFat'] as num?)?.toDouble(),
      );
}

@HiveType(typeId: 2)
class HealthProfile {
  @HiveField(0)
  List<String> conditions;
  @HiveField(1)
  String? medications;
  @HiveField(2)
  String? injuries;

  HealthProfile({
    this.conditions = const [],
    this.medications,
    this.injuries,
  });
}

extension HealthProfileJson on HealthProfile {
  Map<String, dynamic> toJson() => {
        'conditions': conditions,
        'medications': medications,
        'injuries': injuries,
      };

  static HealthProfile fromJson(Map<String, dynamic> json) => HealthProfile(
        conditions: List<String>.from(json['conditions'] ?? []),
        medications: json['medications'],
        injuries: json['injuries'],
      );
}

@HiveType(typeId: 3)
class FitnessGoals {
  @HiveField(0)
  FitnessGoal primaryGoal;
  @HiveField(1)
  ActivityLevel activityLevel;
  @HiveField(2)
  int workoutDaysPerWeek;

  FitnessGoals({
    required this.primaryGoal,
    required this.activityLevel,
    required this.workoutDaysPerWeek,
  });
}

extension FitnessGoalsJson on FitnessGoals {
  Map<String, dynamic> toJson() => {
        'primaryGoal': primaryGoal.name,
        'activityLevel': activityLevel.name,
        'workoutDaysPerWeek': workoutDaysPerWeek,
      };

  static FitnessGoals fromJson(Map<String, dynamic> json) => FitnessGoals(
        primaryGoal: FitnessGoal.values.firstWhere(
          (e) => e.name == json['primaryGoal'],
          orElse: () => FitnessGoal.weightLoss,
        ),
        activityLevel: ActivityLevel.values.firstWhere(
          (e) => e.name == json['activityLevel'],
          orElse: () => ActivityLevel.Intermediate,
        ),
        workoutDaysPerWeek: json['workoutDaysPerWeek'] ?? 3,
      );
}

// @HiveType(typeId: 4)
// class UserChallenge {
//   @HiveField(0)
//   String challengeType;
//   @HiveField(1)
//   String description;
//   @HiveField(2)
//   int targetValue;
//   @HiveField(3)
//   int currentValue;
//   @HiveField(4)
//   bool isCompleted;
//   @HiveField(5)
//   DateTime? startDate;
//   @HiveField(6)
//   DateTime? endDate;

//   UserChallenge({
//     required this.challengeType,
//     required this.description,
//     required this.targetValue,
//     this.currentValue = 0,
//     this.isCompleted = false,
//     this.startDate,
//     this.endDate,
//   });
// }

// extension UserChallengeJson on UserChallenge {
//   Map<String, dynamic> toJson() => {
//         'challengeType': challengeType,
//         'description': description,
//         'targetValue': targetValue,
//         'currentValue': currentValue,
//         'isCompleted': isCompleted,
//         'startDate': startDate?.toIso8601String(),
//         'endDate': endDate?.toIso8601String(),
//       };

//   static UserChallenge fromJson(Map<String, dynamic> json) => UserChallenge(
//         challengeType: json['challengeType'] ?? 'daily',
//         description: json['description'] ?? '',
//         targetValue: json['targetValue'] ?? 0,
//         currentValue: json['currentValue'] ?? 0,
//         isCompleted: json['isCompleted'] ?? false,
//         startDate: json['startDate'] != null
//             ? DateTime.tryParse(json['startDate'])
//             : null,
//         endDate:
//             json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
//       );
// }
