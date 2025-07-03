import 'package:fitbeast/features/fithub/controller/connections_controller.dart';
import 'package:get/get.dart';

class ConnectionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConnectionsController>(
      () => ConnectionsController(),
    );
  }
}
