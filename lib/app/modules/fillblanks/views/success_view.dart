import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/helper/responsive.dart';

class SuccessView extends GetView {
  const SuccessView({super.key});
  @override
  Widget build(BuildContext context) {
    // Get arguments from the navigation route
    int score = 0;
    try {
       score = Get.arguments['score'] as int;
    } catch (e) {
      print("Error retrieving score: $e");
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: secondaryColor,
        actions: [
          IconButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'practiceresults'.tr,
              style: TextStyle(
                fontSize: Responsive.sp(context, 24),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Stack(
              children: [
                Image.asset(
                  'assets/images/ticket.png',
                  width: Responsive.wp(0.75),
                ),
                Positioned(
                  bottom: 60,
                  right: 0,
                  left: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'badgeearned'.tr,
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      CircleAvatar(
                        backgroundColor: primaryColor,
                        radius: Responsive.isTablet(context) ? 34 : 30,
                        backgroundImage: AssetImage(
                          'assets/images/congrats.png',
                        ),
                      ),

                      SizedBox(height: 5),
                      Text(
                        'imu'.tr,
                        style: TextStyle(fontSize: Responsive.sp(context, 12)),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 0,
                  left: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'congratulations'.tr,
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 18),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 5),
                      Text(
                        '${'yougot'.tr} $score ${'outof'.tr} 10 \n${'correctanswers'.tr}',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 16),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                       Text(
                        '$score/10',
                        style: TextStyle(
                          fontSize: Responsive.isTablet(context) ? 42 : 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
