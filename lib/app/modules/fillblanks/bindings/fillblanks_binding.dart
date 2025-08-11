import 'package:get/get.dart';

import '../controllers/fillblanks_controller.dart';

class FillblanksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FillblanksController>(
      () => FillblanksController(),
    );
  }
}
