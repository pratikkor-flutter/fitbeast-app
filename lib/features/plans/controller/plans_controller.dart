import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbeast/enums/fitness_goal_enum.dart';
import 'package:fitbeast/models/diet_workout_plan.dart';
import 'package:fitbeast/models/user_model.dart';
import 'package:fitbeast/repository/user_repository.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PlansController extends GetxController {
  // Diet Plan Properties
  final RxMap<String, dynamic> dietPlans = <String, dynamic>{}.obs;
  final RxList<String> workoutActivities = <String>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentTabIndex = 0.obs; // 0 for Diet, 1 for Workout
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DietWorkoutPlan? _currentPlan;
  UserModel? userModel;
  final RxString dietType = 'Veg'.obs;

  @override
  void onInit() {
    super.onInit();
    checkAndFetchPlans();
  }

  Future<void> fetchPlans() async {
    try {
      isLoading(true);
      errorMessage('');

      userModel = await UserRepository().getUser();

      // Map<String, dynamic> inputData = {
      //   "weight": 70,
      //   "height": 175,
      //   "age": 25,
      //   "gender": "Female",
      //   "diseases": "None",
      //   "fitness_goal": "Muscle Gain",
      //   "workout_days": 5,
      //   "workout_level": "Intermediate",
      //   "diet_type": "Veg"
      // };

      try {
        final inputData = {
          "weight": userModel?.bodyMetrics.weight ?? 0,
          "height": userModel?.bodyMetrics.height ?? 0,
          "age": userModel?.bodyMetrics.age ?? 0,
          "gender": userModel?.bodyMetrics.gender ?? "Male",
          "diseases": userModel?.healthProfile.conditions ?? [],
          "fitness_goal":
              userModel?.fitnessGoals.primaryGoal.label ?? "Weight Maintenance",
          "workout_days": userModel?.fitnessGoals.workoutDaysPerWeek ?? 3,
          "workout_level":
              userModel?.fitnessGoals.activityLevel.name ?? "Beginner",
          "diet_type": dietType.isNotEmpty ? dietType.value : "Veg",
        };

        log('Sending input data: ${jsonEncode(inputData)}');

        final response = await http.post(
          Uri.parse('https://fitbeast-ml-model.onrender.com/recommend'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(inputData),
        );

        log('Response Status: ${response.statusCode}');
        log('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final planResponse = jsonDecode(response.body);
          log('Recommendations: $planResponse');

          _currentPlan = DietWorkoutPlan.fromJson(planResponse);

          log(planResponse.toString());
          dietPlans.assignAll(planResponse['diet_plan'] ?? []);
          workoutActivities
              .assignAll(List<String>.from(planResponse['workout_plan'] ?? []));
          await storeDietWorkoutPlans();
        } else {
          log('API returned status ${response.statusCode}');
          throw Exception('Failed to load plans');
        }
      } catch (e) {
        log('Error sending recommendation request: $e');
        errorMessage(e.toString());
      }
    } finally {
      isLoading(false);
    }
    isLoading(false);
  }

  Future<void> storeDietWorkoutPlans() async {
    try {
      isLoading(true);
      errorMessage('');

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final planJson = _currentPlan!.toJson();

      await _firestore.collection('plans').add({
        'cluster_key': planJson['cluster_key'],
        'diet_plan': planJson['diet_plan'],
        'workout_plan': planJson['workout_plan'],
        'created_at': DateTime.now().toLocal().toIso8601String(),
        'user_id': user.uid,
      });

      log('Plan stored successfully for user ${user.uid}');
    } catch (e) {
      log('Error storing plan: $e');
      throw Exception('Failed to store plan: $e');
    }
  }

  Future<void> checkAndFetchPlans() async {
    try {
      isLoading(true);
      errorMessage('');

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final querySnapshot = await _firestore
          .collection('plans')
          .where('user_id', isEqualTo: user.uid)
          .orderBy('created_at', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final lastPlan = querySnapshot.docs.first;
        final createdAt = DateTime.parse(lastPlan['created_at']);
        final now = DateTime.now();
        final difference = now.difference(createdAt).inDays;

        if (difference < 7) {
          _currentPlan = DietWorkoutPlan.fromJson(lastPlan.data());
          dietPlans.assignAll(lastPlan['diet_plan'] ?? {});
          workoutActivities
              .assignAll(List<String>.from(lastPlan['workout_plan'] ?? []));
          isLoading(false);
          return;
        }
      }
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  void retry() async {
    await checkAndFetchPlans();
  }
}
