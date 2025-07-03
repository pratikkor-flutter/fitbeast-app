import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbeast/features/home/controller/home_controller.dart';
import 'package:fitbeast/models/achievements_model.dart';
import 'package:fitbeast/models/user_model.dart';
import 'package:fitbeast/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // User Info
  final RxString userLevel = 'NA'.obs;
  final RxInt userPoints = 0.obs;
  final RxInt daysStreak = 0.obs;
  final RxInt challengesWon = 0.obs;
  final RxDouble progressToNextLevel = 0.0.obs;
  final RxList<Map<String, dynamic>> userCompletedChallenges =
      <Map<String, dynamic>>[].obs;
  final RxList<Achievement> achievementsList = <Achievement>[].obs;
  UserModel? userModel;
  final uid = FirebaseAuth.instance.currentUser?.uid;

  // Body Metrics and Fitness Stats
  RxMap<String, dynamic> fitnessStats = {
    'Height': 0,
    'Weight': 0,
    'BMI': 'NA',
  }.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _fetchUserChallenges();
    _fetchachievements();
  }

  Future<void> _loadUserData() async {
    userModel = await UserRepository().getUser();
    fitnessStats['Height'] = userModel?.bodyMetrics.height ?? 0;
    fitnessStats['Weight'] = userModel?.bodyMetrics.weight ?? 0;
    fitnessStats['BMI'] = _calculateBMI(
        userModel?.bodyMetrics.weight, userModel?.bodyMetrics.height);
  }

  String _calculateBMI(dynamic weight, dynamic height) {
    if (weight != null && height != null && height > 0) {
      final heightInMeters = height / 100;
      double bmi = weight / (heightInMeters * heightInMeters);
      return bmi.toStringAsFixed(1);
    }
    return 'N/A';
  }

  void _calculateLevel() {
    if (userPoints.value >= 150) {
      userLevel.value = 'Gold';
      progressToNextLevel.value = (userPoints.value - 150) / 100;
    } else if (userPoints.value >= 100) {
      userLevel.value = 'Silver';
      progressToNextLevel.value = (userPoints.value - 100) / 50;
    } else {
      userLevel.value = 'Bronze';
      progressToNextLevel.value = userPoints.value / 100;
    }

    // Cap progress at 1.0
    if (progressToNextLevel.value > 1.0) {
      progressToNextLevel.value = 1.0;
    }
  }

  void updateName(String newName) async {
    Get.find<HomeController>().name.value = newName;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'name': newName});
  }

  void addPoints(int points) {
    userPoints.value += points;
    _calculateLevel();
  }

  Future<void> _fetchUserChallenges() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('user_challenges')
          .get();

      userCompletedChallenges.clear();
      for (var doc in snapshot.docs) {
        if (doc.data().isNotEmpty && doc.data()['progress'] == 100) {
          userCompletedChallenges.add(doc.data());
          challengesWon.value += 1;
          userPoints.value = challengesWon.value * 20;
          log(doc.data().toString());
        }
      }

      // Calculate level based on points
      _calculateLevel();
    } catch (e) {
      print('Error loading user challenges: $e');
    }
  }

  Future<void> _fetchachievements() async {
    try {
      userModel ??= await UserRepository().getUser();

      achievementsList.clear();

      if (userModel != null) {
        for (String achievement in userModel!.achievements) {
          achievementsList.add(
            Achievement(
              title: achievement,
              icon: getIcon(achievement),
              color: getColor(achievement),
            ),
          );
        }
      }
    } catch (e) {
      print('Error loading user achievements: $e');
    }
  }

  IconData getIcon(String iconName) {
    if (iconName.toLowerCase().contains('streak')) {
      return Icons.flash_on;
    } else if (iconName.toLowerCase().contains('workout')) {
      return Icons.fitness_center;
    } else if (iconName == 'Early Bird') {
      return Icons.wb_sunny;
    } else if (iconName.toLowerCase().contains('marathon')) {
      return Icons.directions_run;
    } else if (iconName.toLowerCase().contains('nutrition')) {
      return Icons.restaurant;
    } else {
      return Icons.fitness_center;
    }
  }

  Color getColor(String iconName) {
    if (iconName.toLowerCase().contains('streak')) {
      return Colors.amber;
    } else if (iconName.toLowerCase().contains('workout')) {
      return Colors.blue;
    } else if (iconName == 'Early Bird') {
      return Colors.orange;
    } else if (iconName.toLowerCase().contains('marathon')) {
      return Colors.green;
    } else if (iconName.toLowerCase().contains('nutrition')) {
      return Colors.purple;
    } else {
      return Colors.blue;
    }
  }
}
