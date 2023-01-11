import 'package:get/get.dart';

import '../controllers/updatestatus_controller.dart';

class UpdatestatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdatestatusController>(
      () => UpdatestatusController(),
    );
  }
}
