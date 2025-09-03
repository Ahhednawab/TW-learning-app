import 'package:get/get.dart';
import 'package:mandarinapp/app/modules/favorites/controllers/favorites_controller.dart';

class BottomnavController extends GetxController {
  var tabIndex = 0.obs;

  void changeTabIndex(int index) {

    if (index == 2) {
      Get.find<FavoritesController>().loadFavorites();
    }
    tabIndex.value = index;
  }

}
