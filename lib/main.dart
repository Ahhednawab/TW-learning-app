import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/constants/appconstants.dart';
import 'package:mandarinapp/app/helper/language.dart' as di;
import 'package:mandarinapp/app/helper/messages.dart';
import 'package:mandarinapp/app/services/Localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   // Initialize shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize languages
  Map<String, Map<String, String>> languages = await di.init();

  //Initialize the LocalizationController with Get.put
  Get.put(LocalizationController(sharedPreferences: sharedPreferences));

  runApp(MyApp(languages: languages));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>>? languages;

  const MyApp({Key? key, required this.languages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

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
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            defaultTransition: Transition.topLevel,
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
    );
  }
}
