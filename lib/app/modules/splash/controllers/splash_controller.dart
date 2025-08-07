import 'package:get/get.dart';
import 'package:mandarinapp/app/routes/app_pages.dart';

class SplashController extends GetxController {
  var showSecondImage = false.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 1500), () {
      showSecondImage.value = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
     Get.offNamed(Routes.BOTTOMNAV);
    });
  }
}
