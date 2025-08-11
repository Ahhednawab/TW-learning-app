import 'package:get/get.dart';

import '../controllers/charactermatching_controller.dart';

class CharactermatchingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CharactermatchingController>(
      () => CharactermatchingController(),
    );
  }
}
