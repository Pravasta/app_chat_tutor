import 'package:get/get.dart';

import '../controllers/changeprofile_controller.dart';

class ChangeprofileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangeprofileController>(
      () => ChangeprofileController(),
    );
  }
}
