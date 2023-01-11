import 'package:get/get.dart';

import '../controllers/chatsroom_controller.dart';

class ChatsroomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatsroomController>(
      () => ChatsroomController(),
    );
  }
}
