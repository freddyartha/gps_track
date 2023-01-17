import 'package:get/get.dart';

import '../controllers/map_setup_controller.dart';

class MapSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapSetupController>(
      () => MapSetupController(),
    );
  }
}
