import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitbeast/core/theme/text_theme.dart';
import 'package:fitbeast/core/utils/custom_snackbar.dart';
import 'package:fitbeast/enums/fitness_goal_enum.dart';
import 'package:fitbeast/models/user_model.dart';
import 'package:fitbeast/repository/user_repository.dart';
import 'package:fitbeast/services/google_fit_api/step_count_service.dart';
import 'package:fitbeast/widgets/button_variants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class HomeController extends GetxController {
  final UserRepository userRepository = UserRepository();

  // User Data
  final name = 'beast'.obs;
  final timeOfDay = 'Morning'.obs;

  // Tracking Data
  final caloriesIntake = 0.0.obs;
  final caloriesTarget = 2000.0.obs;
  final caloriesBurned = 0.0.obs;
  final caloriesBurnTarget = 500.0.obs;

  // Water tracking
  final waterIntake = 0.0.obs; // Changed to double for liters
  final waterTarget = 4.0.obs; // Typical 4L daily target
  final waterFrequency = 0.obs; // Times drank today
  final waterFreqTarget = 10.obs; // Times drank target

// Sleep tracking
  final sleepHours = 0.obs; // Changed to double for partial hours
  final sleepTarget = 8.obs; // Typical 8 hours target
  final sleepQuality = 'Good'.obs; // Default quality

  final isMealDone = false.obs;
  final isWorkoutDone = false.obs;
  final goalType = FitnessGoal.weightLoss;

  UserModel? user;

  @override
  void onInit() {
    super.onInit();
    _updateTimeOfDay();
    _loadUserData();
  }

  // done
  void _updateTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      timeOfDay.value = 'Morning';
    } else if (hour < 17) {
      timeOfDay.value = 'Afternoon';
    } else {
      timeOfDay.value = 'Evening';
    }
  }

  // done
  double caloriesProgress() {
    final intakeTarget = caloriesTarget.value;
    final burnTarget = caloriesBurnTarget.value;

    final intakeProgress = intakeTarget > 0
        ? (caloriesIntake.value / intakeTarget).clamp(0.0, 1.0)
        : 0.0;

    final burnProgress = burnTarget > 0
        ? (caloriesBurned.value / burnTarget).clamp(0.0, 1.0)
        : 0.0;

    double intakeWeight = 0.5;
    double burnWeight = 0.5;

    switch (goalType.name.toLowerCase()) {
      case 'weightloss':
        intakeWeight = 0.3;
        burnWeight = 0.7;
        break;
      case 'musclegain':
        intakeWeight = 0.6;
        burnWeight = 0.4;
        break;
      case 'maintenance':
      default:
        intakeWeight = 0.5;
        burnWeight = 0.5;
        break;
    }

    return (intakeProgress * intakeWeight + burnProgress * burnWeight);
  }

  double waterProgress() {
    return waterIntake.value / waterTarget.value;
  }

  double sleepProgress() {
    return sleepHours.value / sleepTarget.value;
  }

  // done
  Future<int> totalSteps() async {
    int totalSteps = await HealthService().fetchTodaySteps();
    log('TOTAL STEPS - $totalSteps');
    return totalSteps;
  }

  // done
  Future<void> _loadUserData() async {
    user = await userRepository.getUser();

    name.value = user?.name ?? 'beast';
    caloriesIntake.value = user?.caloriesIntake ?? 0.0;
    caloriesTarget.value = user?.caloriesTarget ?? 0.0;
    caloriesBurned.value = user?.caloriesBurned ?? 0.0;
    caloriesBurnTarget.value = user?.caloriesBurnTarget ?? 0.0;
    waterIntake.value = user?.waterIntake ?? 0.0;
    waterTarget.value = user?.waterTarget ?? 0.0;
    waterFrequency.value = user?.waterFrequency ?? 0;
    waterFreqTarget.value = user?.waterFreqTarget ?? 0;
    sleepHours.value = user?.sleepHours ?? 0;
    sleepTarget.value = user?.sleepTarget ?? 0;
    sleepQuality.value = user?.sleepQuality ?? 'Good';
  }

  // done
  Future<void> logMeal() async {
    TextEditingController mealTextEditingController = TextEditingController();
    TextEditingController caloriesTextEditingController =
        TextEditingController();

    final result = await Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(Get.context!).colorScheme.onPrimary,
        title: Text('Log Your Meal', style: AppTextTheme.titleMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: mealTextEditingController,
              decoration: InputDecoration(
                labelText: 'What did you eat?',
                labelStyle: AppTextTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: caloriesTextEditingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Calories (kcal)',
                labelStyle: AppTextTheme.bodyMedium,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: null),
            child: Text('Cancel', style: AppTextTheme.titleSmall),
          ),
          ButtonVariants.primary(
            onPressed: () => Get.back(result: {
              'food': mealTextEditingController.text.trim(),
              'calories': caloriesTextEditingController.text.trim()
            }),
            text: 'Log Meal',
          ),
        ],
      ),
    );

    if (result != null) {
      caloriesIntake.value += int.parse(result['calories']);
      isMealDone.value = true;

      final lastUpdated = DateTime.now().toLocal();

      final box = await Hive.openBox<UserModel>('users');
      final user = box.get('currentUser');

      if (user != null) {
        user.caloriesIntake = caloriesIntake.value;
        user.lastUpdated = lastUpdated;
        await user.save();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'caloriesIntake': caloriesIntake.value,
        'lastUpdated': lastUpdated.toIso8601String(),
      });

      showFitSnackbar('Calories intake logged successfully!');
    }
  }

  // done
  Future<void> logWorkout() async {
    TextEditingController workoutTextEditingController =
        TextEditingController();
    TextEditingController caloriesTextEditingController =
        TextEditingController();

    final result = await Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(Get.context!).colorScheme.onPrimary,
        title: Text('Log Your Workout', style: AppTextTheme.titleMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: workoutTextEditingController,
              decoration: InputDecoration(
                labelText: 'What workout did you do?',
                labelStyle: AppTextTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: caloriesTextEditingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Calories burned (kcal)',
                labelStyle: AppTextTheme.bodyMedium,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: null),
            child: Text('Cancel', style: AppTextTheme.titleSmall),
          ),
          ButtonVariants.primary(
            onPressed: () => Get.back(result: {
              'workout': workoutTextEditingController.text.trim(),
              'calories': caloriesTextEditingController.text.trim(),
            }),
            text: 'Log Workout',
          ),
        ],
      ),
    );

    if (result != null) {
      caloriesBurned.value += int.parse(result['calories']);
      isWorkoutDone.value = true;

      final lastUpdated = DateTime.now().toLocal();

      final box = await Hive.openBox<UserModel>('users');
      final user = box.get('currentUser');

      if (user != null) {
        user.caloriesBurned = caloriesBurned.value;
        user.lastUpdated = lastUpdated;
        await user.save();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'caloriesBurned': caloriesBurned.value,
        'lastUpdated': lastUpdated.toIso8601String(),
      });

      showFitSnackbar('Calories burned logged successfully!');
    }
  }

  Future<void> logWater() async {
    TextEditingController amountController = TextEditingController();
    TextEditingController frequencyController = TextEditingController();

    final result = await Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(Get.context!).colorScheme.onPrimary,
        title: Text('Log Water Intake', style: AppTextTheme.titleMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (liters)',
                labelStyle: AppTextTheme.bodyMedium,
                suffixText: 'L',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: frequencyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Times drank today',
                labelStyle: AppTextTheme.bodyMedium,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: null),
            child: Text('Cancel', style: AppTextTheme.titleSmall),
          ),
          ButtonVariants.primary(
            onPressed: () {
              if (amountController.text.isEmpty ||
                  frequencyController.text.isEmpty) {
                showFitSnackbar('Please fill all fields', isError: true);
                return;
              }
              Get.back(result: {
                'amount': amountController.text.trim(),
                'frequency': frequencyController.text.trim()
              });
            },
            text: 'Log Water',
          ),
        ],
      ),
    );

    if (result != null) {
      waterIntake.value += double.parse(result['amount']);
      waterFrequency.value += int.parse(result['frequency']);

      final lastUpdated = DateTime.now().toLocal();

      final box = await Hive.openBox<UserModel>('users');
      final user = box.get('currentUser');

      if (user != null) {
        user.waterIntake = waterIntake.value;
        user.waterFrequency = waterFrequency.value;
        user.lastUpdated = lastUpdated;
        await user.save();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'waterIntake': waterIntake.value,
        'waterFrequency': waterFrequency.value,
        'lastUpdated': lastUpdated.toIso8601String(),
      });

      showFitSnackbar('Water intake logged successfully!');
    }
  }

  Future<void> logSleep() async {
    TextEditingController hoursController = TextEditingController();
    final qualityOptions = ['Poor', 'Fair', 'Good', 'Excellent'];
    String? selectedQuality;

    final result = await Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(Get.context!).colorScheme.onPrimary,
        title: Text('Log Sleep Data', style: AppTextTheme.titleMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: hoursController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Hours slept',
                labelStyle: AppTextTheme.bodyMedium,
                suffixText: 'hours',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Sleep quality',
                labelStyle: AppTextTheme.bodyMedium,
              ),
              items: qualityOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: AppTextTheme.bodyMedium),
                );
              }).toList(),
              onChanged: (value) => selectedQuality = value,
              value: selectedQuality,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: null),
            child: Text('Cancel', style: AppTextTheme.titleSmall),
          ),
          ButtonVariants.primary(
            onPressed: () {
              if (hoursController.text.isEmpty || selectedQuality == null) {
                showFitSnackbar('Please fill all fields', isError: true);
                return;
              }
              Get.back(result: {
                'hours': hoursController.text.trim(),
                'quality': selectedQuality
              });
            },
            text: 'Log Sleep',
          ),
        ],
      ),
    );

    if (result != null) {
      sleepHours.value += int.parse(result['hours']);
      sleepQuality.value = result['quality'];

      final lastUpdated = DateTime.now();

      final box = await Hive.openBox<UserModel>('users');
      final user = box.get('currentUser');

      if (user != null) {
        user.sleepHours = sleepHours.value;
        user.sleepQuality = sleepQuality.value;
        user.lastUpdated = lastUpdated;
        await user.save();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'sleepHours': sleepHours.value,
        'sleepQuality': sleepQuality.value,
      });

      showFitSnackbar('Sleep data logged successfully!');
    }
  }
}
