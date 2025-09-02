import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/constants/appconstants.dart';
import 'package:mandarinapp/app/helper/language.dart' as di;
import 'package:mandarinapp/app/helper/messages.dart';
import 'package:mandarinapp/app/services/Localization.dart';
import 'package:mandarinapp/app/services/messaging_service.dart';
import 'package:mandarinapp/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp();
  
   // Initialize shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize languages
  Map<String, Map<String, String>> languages = await di.init();

  //Initialize the LocalizationController with Get.put
  Get.put(LocalizationController(sharedPreferences: sharedPreferences));
  await Firebase.initializeApp();
  FirebaseMessagingService firebaseMessagingService = FirebaseMessagingService();
  await firebaseMessagingService.initialize();
  await firebaseMessagingService.getToken();
  // await LocalStorageService.getPrefs();

  runApp(MyApp(languages: languages));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>>? languages;

  const MyApp({Key? key, required this.languages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final INITIAL = FirebaseAuth.instance.currentUser != null  ? Routes.BOTTOMNAV : Routes.LOGIN;
    return GetBuilder<LocalizationController>(
      builder: (localizeController) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(
            textScaler: TextScaler.linear(
              size.shortestSide < 400
                  ? 0.85 // very small phones
                  : size.shortestSide < 600
                      ? 0.95 // normal phones
                      : 1.05, // tablets get a slight bump
            ),
          ),
          child: GetMaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            navigatorKey: Get.key,
            theme: ThemeData(
              primarySwatch: Colors.orange,
              scaffoldBackgroundColor: scaffoldColor,
            ),
            locale: localizeController.locale,
            translations: Messages(languages: languages),
            fallbackLocale: Locale(
              AppConstants.languages[0].languageCode!,
              AppConstants.languages[0].countryCode,
            ),
            initialRoute: INITIAL,
            getPages: AppPages.routes,
            defaultTransition: Transition.topLevel,
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
    );
  }
}
