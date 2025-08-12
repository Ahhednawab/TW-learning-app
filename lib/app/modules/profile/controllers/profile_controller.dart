import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';

class ProfileController extends GetxController {
  var isNotificationEnabled = true.obs;

  void toggleNotification(bool value) {
    isNotificationEnabled.value = value;
  }

  List<String> languages = ["English", "Chinese", "Japanese"];

  void showLanguageSelectionDialog() {
    Get.defaultDialog(
      title: "Select Language",
      titleStyle: TextStyle(fontWeight: FontWeight.bold),
      backgroundColor: whiteColor,
      titlePadding: EdgeInsets.all(16),

      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      radius: 8,
      content: Column(
        children: [
          SizedBox(
            height: 150, 
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: languages.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      minTileHeight: 8,
                      title: Text(languages[index]),
                      onTap: () {
                        // Handle language selection
                        Get.back();
                      },
                    ),
                    Divider(
                      indent: 10,
                      endIndent: 10,
                      color: greyColor.withValues(alpha: 0.5),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "Set Language",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
