import 'package:get/get.dart';

import '../controllers/gamesselection_controller.dart';

class GamesselectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GamesselectionController>(
      () => GamesselectionController(),
    );
  }
}
