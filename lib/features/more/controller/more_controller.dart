import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbeast/core/theme/theme_service.dart';
import 'package:fitbeast/core/utils/custom_snackbar.dart';
import 'package:fitbeast/routes/app_routes.dart';
import 'package:fitbeast/services/local_storage_get/local_storage_get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoreController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxBool isDarkTheme = false.obs;

  final RxString name = ''.obs;
  final TextEditingController specialityController = TextEditingController();
  RxString specialityError = ''.obs;
  final TextEditingController gymController = TextEditingController();
  RxString gymError = ''.obs;
  final TextEditingController experienceController = TextEditingController();
  RxString experienceError = ''.obs;

  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize theme from preferences
    isDarkTheme.value = Get.isDarkMode;
    _loadUserName();
  }

  void _loadUserName() {
    final user = _auth.currentUser;
    if (user != null) {
      name.value = user.displayName ?? "Trainer";
    }
  }

  void toggleTheme() {
    isDarkTheme.toggle();
    // Save theme preference
    ThemeService().switchTheme();
  }

  bool validate() {
    if (specialityController.text.trim().isEmpty) {
      specialityError.value = 'Speciality required';
      return false;
    }
    specialityError.value = '';

    if (gymController.text.trim().isEmpty) {
      gymError.value = 'Gym required or enter Freelancer';
      return false;
    }
    gymError.value = '';

    if (experienceController.text.trim().isEmpty) {
      experienceError.value = 'Experience required (can enter 0)';
      return false;
    }
    experienceError.value = '';

    return true;
  }

  Future<void> submitTrainerApplication() async {
    isSubmitting.value = true;

    if (!validate()) {
      isSubmitting.value = false;

      return;
    }

    final user = _auth.currentUser;
    if (user == null) {
      showFitSnackbar("User not logged in", isError: true);
      isSubmitting.value = false;
      return;
    }

    final trainerData = {
      "uid": user.uid,
      "name": name.value,
      "speciality": specialityController.text,
      "gym": gymController.text,
      "experience": experienceController.text,
      "appliedAt": DateTime.now().toIso8601String(),
    };

    try {
      await _firestore.collection('trainers').doc(user.uid).set(trainerData);
      Get.back();
      showFitSnackbar("Application submitted successfully");
    } catch (e) {
      showFitSnackbar("Failed to submit: $e", isError: true);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> checkForTrainerStatus() async {
    final user = _auth.currentUser;
    if (user == null) {
      showFitSnackbar("User not logged in", isError: true);
      return false;
    }

    final docSnapshot = await FirebaseFirestore.instance
        .collection('trainers')
        .doc(user.uid)
        .get();

    return docSnapshot.exists;
  }

  void navigateTo(String route) {
    Get.toNamed(route);
  }

  Future<void> logout() async {
    // TODO:Implement logout logic
    await FirebaseAuth.instance.signOut();
    await LocalStorageGet().clearUserData();
    Get.offAllNamed(Routes.login);
  }
}
