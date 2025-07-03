import 'dart:developer';

import 'package:fitbeast/core/utils/custom_snackbar.dart';
import 'package:fitbeast/enums/activity_level_enum.dart';
import 'package:fitbeast/enums/fitness_goal_enum.dart';
import 'package:fitbeast/models/user_model.dart';
import 'package:fitbeast/repository/user_repository.dart';
import 'package:fitbeast/routes/app_routes.dart';
import 'package:fitbeast/services/local_storage_get/local_storage_get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PostRegOnboardingController extends GetxController {
  UserRepository userRepository = UserRepository();
  // Screen Management
  final RxInt currentScreenIndex = 0.obs;
  final totalScreens = 3;
  final PageController pageController = PageController();
  RxBool isLoading = false.obs;

  // User Data
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final ageController = TextEditingController();
  final gender = RxString('Male');
  final goalWeightController = TextEditingController();
  final bodyFatController = TextEditingController();

  final medicationsController = TextEditingController();
  final injuriesController = TextEditingController();
  final fitnessGoal = RxString('Weight Maintenance');
  final activityLevel = RxString('Intermediate');
  final workoutDays = RxInt(3);

  RxString ageError = RxString('');
  RxString heightError = RxString('');
  RxString weightError = RxString('');

  // List of all available medical conditions
  final List<String> medicalConditions = [
    'Diabetes',
    'Hypertension',
    'Asthma',
    'Heart Disease',
    'None',
  ];

// RxList to hold selected conditions
  final RxList<String> selectedConditions = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAndLoadUser();
  }

  Future<void> fetchAndLoadUser() async {
    final user = await userRepository.getUser();
    if (user != null) {
      loadUserData(user);
    }
  }

  // Progress Calculation (0.0 to 1.0)
  RxDouble get completionProgress {
    double progress = 0.0;

    // Screen 1 Progress (30%)
    if (heightController.text.isNotEmpty && weightController.text.isNotEmpty) {
      progress += 0.3;
    }

    // Screen 2 Progress (30%)
    if (selectedConditions.isNotEmpty) {
      progress += 0.3;
    }

    // Screen 3 Progress (40%)
    if (fitnessGoal.value.isNotEmpty && workoutDays.value > 0) {
      progress += 0.4;
    }

    return progress.clamp(0.0, 1.0).obs;
  }

  // Navigation
  Future<void> nextScreen() async {
    if (currentScreenIndex.value < totalScreens - 1) {
      pageController.nextPage(
        duration: 500.ms,
        curve: Curves.easeInOut,
      );
      currentScreenIndex.value++;
    } else {
      await completeOnboarding();
    }
  }

  void previousScreen() {
    if (currentScreenIndex.value > 0) {
      pageController.previousPage(
        duration: 500.ms,
        curve: Curves.easeInOut,
      );
      currentScreenIndex.value--;
    }
  }

  void skipOnboarding() {
    Get.offAllNamed(Routes.appShell);
  }

  void validateBodyMetrics() {}

  // Toggle selection of a condition
  void toggleCondition(String condition) {
    if (selectedConditions.contains(condition)) {
      selectedConditions.remove(condition);
    } else {
      // You can allow multiple, or handle 'None' as exclusive
      if (condition == 'None') {
        selectedConditions.value = ['None'];
      } else {
        selectedConditions.remove('None'); // if 'None' is selected, remove it
        selectedConditions.add(condition);
      }
    }
  }

  Future<void> completeOnboarding() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      UserModel? userModel = await UserRepository().getUser();

      final targets = calculateHealthTargets(
        height: double.parse(heightController.text.trim()),
        weight: double.parse(weightController.text.trim()),
        age: int.parse(ageController.text.trim()),
        gender: gender.value,
        goal: FitnessGoal.values
            .firstWhere(
              (e) => e.name == fitnessGoal.value,
              orElse: () => FitnessGoal.weightLoss,
            )
            .name,
        workoutDays: workoutDays.value,
      );

      final now = DateTime.now().toLocal();

      final todayMidnight = DateTime(now.year, now.month, now.day, 0, 0);

      final userData = UserModel(
        uid: user.uid,
        streak: userModel?.streak ?? 0,
        name: userModel?.name ?? '',
        username: userModel?.username ?? '',
        email: user.email ?? '',
        onboardingComplete: true,
        bodyMetrics: BodyMetrics(
          height: double.parse(heightController.text.trim()),
          weight: double.parse(weightController.text.trim()),
          age: int.parse(ageController.text.trim()),
          gender: gender.value,
          goalWeight: double.tryParse(goalWeightController.text),
          bodyFat: double.tryParse(bodyFatController.text),
        ),
        healthProfile: HealthProfile(
          conditions: selectedConditions,
          medications: medicationsController.text,
          injuries: injuriesController.text,
        ),
        fitnessGoals: FitnessGoals(
          primaryGoal: FitnessGoal.values.firstWhere(
            (e) => e.name == fitnessGoal.value,
            orElse: () => FitnessGoal.weightLoss,
          ),
          activityLevel: ActivityLevel.values.firstWhere(
            (e) => e.name == activityLevel.value,
            orElse: () => ActivityLevel.Intermediate,
          ),
          workoutDaysPerWeek: workoutDays.value,
        ),
        lastUpdated: DateTime.now(),
        logValidityDate: todayMidnight,
        achievements: checkFirstOnBoardAchievement(userModel?.achievements),
        caloriesIntake: userModel?.caloriesIntake ?? 0.0,
        caloriesTarget: targets['caloriesIntakeTarget'] ?? 0.0,
        caloriesBurned: userModel?.caloriesBurned ?? 0.0,
        caloriesBurnTarget: targets['caloriesBurnTarget'] ?? 0.0,
        waterIntake: userModel?.waterIntake ?? 0.0,
        waterTarget: targets['waterTarget'] ?? 4.0,
        waterFrequency: userModel?.waterFrequency ?? 0,
        waterFreqTarget: targets['waterFreqTarget'] ?? 0,
        sleepHours: userModel?.sleepHours ?? 0,
        sleepTarget: targets['sleepTarget'] ?? 0,
        sleepQuality: userModel?.sleepQuality ?? '',
      );

      // into firestore & hive
      await userRepository.setUser(userData);

      // Show success animation
      Get.toNamed(Routes.postRegOnboardingSuccess);

      // set onboarding complete in get
      await LocalStorageGet().setPostRegOnboardingComplete();

      // Navigate home after delay
      await Future.delayed(const Duration(seconds: 3));

      Get.offAllNamed(Routes.appShell);
    } catch (e, st) {
      log(e.toString());
      log(st.toString());
      showFitSnackbar('Failed to save data', isError: true);
    }
  }

  List<String> checkFirstOnBoardAchievement(List<String>? achievements) {
    if (achievements != null && achievements.isNotEmpty) {
      if (achievements.contains('Early Bird')) return achievements;
    }

    return ['Early Bird'];
  }

  Map<String, dynamic> calculateHealthTargets({
    required double height, // in cm
    required double weight, // in kg
    required int age,
    required String gender,
    required String goal,
    required int workoutDays,
  }) {
    // BMR (Basal Metabolic Rate)
    double bmr;
    if (gender == 'Male') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    // Activity Factor
    double activityFactor = 1.2 + (workoutDays * 0.1);
    double maintenanceCalories = bmr * activityFactor;

    // water multiplier
    double waterMultiplier = 40;

    // burn calories multiplier
    double burnCaloriesMultiplier = 40;

    // Goal Adjustment
    double calorieIntake;
    switch (goal) {
      case 'Weight Loss':
        calorieIntake = maintenanceCalories - 500;
        waterMultiplier = 50;
        burnCaloriesMultiplier = 400;
        break;
      case 'Muscle Gain':
        calorieIntake = maintenanceCalories + 300;
        waterMultiplier = 55;
        burnCaloriesMultiplier = 100;
        break;
      default:
        calorieIntake = maintenanceCalories;
        waterMultiplier = 45;
        burnCaloriesMultiplier = 200;
    }

    // Calorie Burn Estimate
    double calorieBurnTarget =
        workoutDays * burnCaloriesMultiplier; // average burn per session

    // Water Intake (liters)
    double waterTargetMl = weight * waterMultiplier;
    double waterTargetLiters = waterTargetMl / 1000; // Convert ml to liters
    int waterFrequencyTarget =
        (waterTargetMl / 250).round(); // Number of 250ml glasses

    // Sleep Hours
    int sleepTarget = (age <= 25)
        ? (goal == 'Muscle Gain' ? 9 : 8)
        : (goal == 'Muscle Gain' ? 8 : 7);

    return {
      'caloriesIntakeTarget': calorieIntake,
      'caloriesBurnTarget': calorieBurnTarget,
      'waterTarget': waterTargetLiters,
      'waterFreqTarget': waterFrequencyTarget,
      'sleepTarget': sleepTarget,
    };
  }

  void loadUserData(UserModel user) {
    // Body Metrics
    heightController.text = user.bodyMetrics.height?.toString() ?? '';
    weightController.text = user.bodyMetrics.weight?.toString() ?? '';
    ageController.text = user.bodyMetrics.age?.toString() ?? '';
    gender.value = user.bodyMetrics.gender ?? '';
    goalWeightController.text = user.bodyMetrics.goalWeight?.toString() ?? '';
    bodyFatController.text = user.bodyMetrics.bodyFat?.toString() ?? '';

    // Health Profile
    selectedConditions.assignAll(user.healthProfile.conditions);
    medicationsController.text = user.healthProfile.medications ?? '';
    injuriesController.text = user.healthProfile.injuries ?? '';

    // Fitness Goals
    fitnessGoal.value = user.fitnessGoals.primaryGoal.name;
    activityLevel.value = user.fitnessGoals.activityLevel.name;
    workoutDays.value = user.fitnessGoals.workoutDaysPerWeek;
  }

  @override
  void onClose() {
    heightController.dispose();
    weightController.dispose();
    goalWeightController.dispose();
    bodyFatController.dispose();
    medicationsController.dispose();
    injuriesController.dispose();
    pageController.dispose();
    super.onClose();
  }
}
