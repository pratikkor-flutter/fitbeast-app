import 'package:fitbeast/features/post_reg_onboarding/controller/post_reg_onboarding_controller.dart';
import 'package:get/get.dart';

class PostRegOnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostRegOnboardingController>(
      () => PostRegOnboardingController(),
    );
  }
}
