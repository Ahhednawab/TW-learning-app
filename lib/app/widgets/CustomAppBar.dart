import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';

PreferredSizeWidget customAppBar({
  // required VoidCallback onBackPressed,
  bool implyleading = false,
  required String title,
  }) {
  return AppBar(
    backgroundColor: scaffoldColor,
    surfaceTintColor: scaffoldColor,
    title: Text(
      title.tr,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
    leading: implyleading ? null: InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => Get.back(),
      child: const Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 24,
        color: Colors.black,
      ),
    ),
  );
}
