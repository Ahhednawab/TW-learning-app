import 'package:get/get.dart';

class GamesselectionController extends GetxController {
 String? activity;

 
  @override
  void onInit() {
    super.onInit();
    activity = Get.arguments['activity'];
  }

  
}
