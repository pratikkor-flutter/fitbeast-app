import 'package:fitbeast/features/navbar/controller/navbar_controller.dart';
import 'package:get/get.dart';

class NavbarBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavbarController>(() => NavbarController(), fenix: true);
  }
}
