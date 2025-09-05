import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/colors.dart';
import 'package:mandarinapp/app/helper/responsive.dart';
import 'package:mandarinapp/app/modules/chooseactivity/controllers/chooseactivity_controller.dart';
import 'package:mandarinapp/app/modules/gamesselection/controllers/gamesselection_controller.dart';

class SuccessView extends GetView {
  const SuccessView({super.key});
  @override
  Widget build(BuildContext context) {
    // Get arguments from the navigation route
    int score = 0;
    int totalQuestions = 0;
    try {
       score = Get.arguments['correctAnswers'] as int;
       totalQuestions = Get.arguments['totalQuestions'] as int;
    } catch (e) {
      print("Error retrieving score: $e");
    }
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          // Refresh games selection screen when user navigates back
          try {
            final controller = Get.find<GamesselectionController>();
            controller.refreshProgress();
          } catch (e) {
            print('Games selection controller not found: $e');
          }
          try {
            final controller2 = Get.find<ChooseactivityController>();
            controller2.refreshData();
          } catch (e) {
            print('Choose activity controller not found: $e');
          }
        }
      },
      child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: secondaryColor,
        actions: [
          IconButton(
            onPressed: () {
              try {
                final controller = Get.find<GamesselectionController>();
                controller.refreshProgress();
              } catch (e) {
                print('Games selection controller not found: $e');
              }
              try {
                final controller2 = Get.find<ChooseactivityController>();
                controller2.refreshData();
              } catch (e) {
                print('Choose activity controller not found: $e');
              }
              // Get.back();
              Get.back();
            },
              // Refresh games selection screen
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
                fontSize: Responsive.sp(context, 26),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Stack(
              children: [
                Image.asset(
                  'assets/images/ticket.png',
                  width: Responsive.wp(0.90),
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
                          fontSize: Responsive.sp(context, 22),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      CircleAvatar(
                        backgroundColor: primaryColor,
                        radius: Responsive.isTablet(context) ? 38 : 34,
                        backgroundImage: AssetImage(
                          'assets/images/congrats.png',
                        ),
                      ),

                      // SizedBox(height: 5),
                      // Text(
                      //   'imu'.tr,
                      //   style: TextStyle(fontSize: Responsive.sp(context, 12)),
                      // ),
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
                          fontSize: Responsive.sp(context, 26),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 5),
                      Text(
                        '${'yougot'.tr} $score ${'outof'.tr} $totalQuestions \n${'correctanswers'.tr}',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 18),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                       Text(
                        '$score/$totalQuestions',
                        style: TextStyle(
                          fontSize: Responsive.isTablet(context) ? 42 : 38,
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
      ),
    );
  }
}
