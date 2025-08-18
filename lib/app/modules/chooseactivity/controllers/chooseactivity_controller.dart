import 'package:get/get.dart';

class ChooseactivityController extends GetxController {
  String? activity;

  @override
  void onInit() {
    super.onInit();
    try {
      activity = Get.arguments['activity'];
    } catch (e) {
      activity = 'chooseactivity';
    }
  }


}
