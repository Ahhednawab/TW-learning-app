import 'package:get/get.dart';

class HomeController extends GetxController {

  final count = 0.obs;
  RxString? selectedLanguage = 'English'.obs;

  List<String> languages = ['English', 'Chinese', 'Japanese'];
  @override
  void onInit() {
    super.onInit();
  }


}
