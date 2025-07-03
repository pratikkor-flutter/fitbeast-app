import 'package:fitbeast/features/challenges/controller/challenge_controller.dart';
import 'package:get/get.dart';

class ChallengeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChallengeController>(
      () => ChallengeController(),
    );
  }
}
