import 'dart:developer';

import 'package:fitbeast/routes/app_routes.dart';
import 'package:get/get.dart';

class NavbarController extends GetxController {
  static NavbarController get to => Get.find();

  final initialRoute = Get.nestedKey(1)?.currentState?.widget.initialRoute;

  final RxInt currentIndex = 0.obs;
  final List<String> routeNames = [
    Routes.home,
    Routes.plans,
    Routes.community,
    Routes.challenges,
    Routes.more,
  ];

  void changeTab(int index) {
    log('INDEX - $index');
    if (currentIndex.value != index) {
      currentIndex.value = index;

      if (initialRoute == routeNames[index]) {
        // Force re-push the route manually, just required for initial route(Home)
        Get.nestedKey(1)?.currentState?.pushReplacementNamed(routeNames[index]);
      } else {
        Get.offNamed(routeNames[index], id: 1); // Navigator key for shell
      }
    }
  }
}
