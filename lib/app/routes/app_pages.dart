import 'package:get/get.dart';

import '../modules/bottomnav/bindings/bottomnav_binding.dart';
import '../modules/bottomnav/views/bottomnav_view.dart';
import '../modules/chooseactivity/bindings/chooseactivity_binding.dart';
import '../modules/chooseactivity/views/chooseactivity_view.dart';
import '../modules/editprofile/bindings/editprofile_binding.dart';
import '../modules/editprofile/views/editprofile_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/swipecard/bindings/swipecard_binding.dart';
import '../modules/swipecard/views/swipecard_view.dart';
import '../modules/vocabulary/bindings/vocabulary_binding.dart';
import '../modules/vocabulary/views/vocabulary_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOMNAV,
      page: () => const BottomnavView(),
      binding: BottomnavBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDITPROFILE,
      page: () => const EditprofileView(),
      binding: EditprofileBinding(),
    ),
    GetPage(
      name: _Paths.VOCABULARY,
      page: () => const VocabularyView(),
      binding: VocabularyBinding(),
    ),
    GetPage(
      name: _Paths.CHOOSEACTIVITY,
      page: () => const ChooseactivityView(),
      binding: ChooseactivityBinding(),
    ),
    GetPage(
      name: _Paths.SWIPECARD,
      page: () => const SwipecardView(),
      binding: SwipecardBinding(),
    ),
  ];
}
