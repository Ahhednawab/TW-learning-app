import 'package:get/get.dart';

import '../modules/bottomnav/bindings/bottomnav_binding.dart';
import '../modules/bottomnav/views/bottomnav_view.dart';
import '../modules/charactermatching/bindings/charactermatching_binding.dart';
import '../modules/charactermatching/views/charactermatching_view.dart';
import '../modules/chooseactivity/bindings/chooseactivity_binding.dart';
import '../modules/chooseactivity/views/chooseactivity_view.dart';
import '../modules/editprofile/bindings/editprofile_binding.dart';
import '../modules/editprofile/views/editprofile_view.dart';
import '../modules/favorites/bindings/favorites_binding.dart';
import '../modules/favorites/views/favorites_view.dart';
import '../modules/fillblanks/bindings/fillblanks_binding.dart';
import '../modules/fillblanks/views/fillblanks_view.dart';
import '../modules/fillblanks/views/success_view.dart' as fs;
import '../modules/gamesselection/bindings/gamesselection_binding.dart';
import '../modules/gamesselection/views/gamesselection_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/listening/bindings/listening_binding.dart';
import '../modules/listening/views/listening_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/quiz/bindings/quiz_binding.dart';
import '../modules/quiz/views/quiz_view.dart';
import '../modules/quiz/views/success_view.dart';
import '../modules/quiz/views/failure_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
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
    GetPage(
      name: _Paths.GAMESSELECTION,
      page: () => const GamesselectionView(),
      binding: GamesselectionBinding(),
    ),
    GetPage(
      name: _Paths.FILLBLANKS,
      page: () => const FillblanksView(),
      binding: FillblanksBinding(),
    ),
    GetPage(
      name: _Paths.CHARACTERMATCHING,
      page: () => const CharactermatchingView(),
      binding: CharactermatchingBinding(),
    ),
    GetPage(
      name: _Paths.LISTENING,
      page: () => const ListeningView(),
      binding: ListeningBinding(),
    ),
    GetPage(
      name: _Paths.QUIZ,
      page: () => const QuizView(),
      binding: QuizBinding(),
    ),
    GetPage(
      name: _Paths.SUCCESS,
      page: () => const SuccessView(),
    ),
    GetPage(
      name: _Paths.QUIZFAILURE,
      page: () => const QuizFailureView(),
    ),
    GetPage(
      name: _Paths.FAVORITES,
      page: () => const FavoritesView(),
      binding: FavoritesBinding(),
    ),
    GetPage(
      name: _Paths.FILLSUCCESS,
      page: () => const fs.SuccessView(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignupView(),
      binding: SignupBinding(),
    ),
  ];
}
