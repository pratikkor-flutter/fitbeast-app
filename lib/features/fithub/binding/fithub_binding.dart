import 'package:fitbeast/features/fithub/controller/fithub_controller.dart';
import 'package:get/get.dart';

class FithubBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FithubController>(
      () => FithubController(),
    );
  }
}
