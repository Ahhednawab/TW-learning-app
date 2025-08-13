import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../constants/Colors.dart';

Widget HomeGreeting({required userName}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'hi'.tr+' $userName,',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: blackColor,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        "learnsomething".tr,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          color: greyColor,
        ),
      ),
    ],
  );
}
