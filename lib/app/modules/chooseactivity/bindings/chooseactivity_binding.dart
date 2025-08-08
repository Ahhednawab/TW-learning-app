import 'package:get/get.dart';

import '../controllers/chooseactivity_controller.dart';

class ChooseactivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChooseactivityController>(
      () => ChooseactivityController(),
    );
  }
}
