import 'package:mandarinapp/app/models/language.dart';

class AppConstants {

  // App Name
  static const String appName = 'TW Learning App';

  // Shared Key
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';


  // Languages
  static List<LanguageModel> languages = [
    LanguageModel(
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
    LanguageModel(
        languageName: '中文',
        countryCode: 'CN',
        languageCode: 'zh'),
    LanguageModel(
        languageName: '日本語',
        countryCode: 'JP',
        languageCode: 'ja'),
  ];
}