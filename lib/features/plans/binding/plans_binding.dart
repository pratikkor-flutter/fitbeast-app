import 'package:fitbeast/features/plans/controller/plans_controller.dart';
import 'package:get/get.dart';

class PlansBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlansController>(
      () => PlansController(),
    );
  }
}
