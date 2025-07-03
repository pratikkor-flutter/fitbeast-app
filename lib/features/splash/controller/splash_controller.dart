import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitbeast/core/constants/app_constants.dart';
import 'package:fitbeast/models/user_model.dart';
import 'package:fitbeast/repository/user_repository.dart';
import 'package:fitbeast/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';

class SplashController extends GetxController {
  final GetStorage _storage = GetStorage();
  final RxBool isLoading = true.obs;

  @override
  void onReady() {
    super.onReady();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));

    final bool isLoggedIn =
        _storage.read(LocalStorageKeys.userLoginKey) ?? false;
    final bool onboardingComplete =
        _storage.read(LocalStorageKeys.onboardingKey) ?? false;
    final bool postRegOnboardingComplete =
        _storage.read(LocalStorageKeys.postRegOnboardingKey) ?? false;

    UserModel? userModel = await UserRepository().getUser();

    if (userModel != null) {
      final now = DateTime.now().toLocal();

      if (now.difference(userModel.logValidityDate) >
          const Duration(hours: 24)) {
        final lastUpdated = DateTime.now();

        final box = await Hive.openBox<UserModel>('users');
        final user = box.get('currentUser');

        if (user != null) {
          user.caloriesIntake = 0.0;
          user.caloriesBurned = 0.0;
          user.waterIntake = 0.0;
          user.waterFrequency = 0;
          user.sleepHours = 0;
          user.sleepQuality = '';
          user.lastUpdated = lastUpdated;
          await user.save();
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({
          'caloriesIntake': 0.0,
          'caloriesBurned': 0.0,
          'waterIntake': 0.0,
          'waterFrequency': 0,
          'sleepHours': 0,
          'sleepQuality': '',
          'lastUpdated': lastUpdated,
        });
      }
    }
    if (isLoggedIn) {
      if (postRegOnboardingComplete) {
        Get.offNamed(Routes.appShell);
      } else {
        Get.offNamed(Routes.postReg);
      }
    } else if (onboardingComplete) {
      Get.offNamed(Routes.login);
    } else {
      Get.offNamed(Routes.onboarding);
    }

    isLoading.value = false;
  }
}
