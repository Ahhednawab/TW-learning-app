import 'package:get/get.dart';

class HomeController extends GetxController {

  final count = 0.obs;
  RxString? selectedLanguage = 'en'.obs;

  List<String> languages = ['en', 'zh', 'ja'];
  @override
  void onInit() {
    super.onInit();
  }


}
