import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mandarinapp/app/constants/appconstants.dart';
import 'package:mandarinapp/app/models/language.dart';

Future<Map<String, Map<String, String>>> init() async {
    Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/languages/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    Map<String, String> jsonValue = {};
    mappedJson.forEach((key, value) {
      jsonValue[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = jsonValue;
  }
  return languages;
}