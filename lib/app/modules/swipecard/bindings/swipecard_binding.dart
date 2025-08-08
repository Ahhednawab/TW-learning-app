import 'package:get/get.dart';

import '../controllers/swipecard_controller.dart';

class SwipecardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SwipecardController>(
      () => SwipecardController(),
    );
  }
}
