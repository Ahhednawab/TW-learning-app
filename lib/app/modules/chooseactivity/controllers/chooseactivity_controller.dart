import 'package:get/get.dart';

class ChooseactivityController extends GetxController {
  String? activity;

  @override
  void onInit() {
    super.onInit();
    activity = Get.arguments['activity'];
  }


}
