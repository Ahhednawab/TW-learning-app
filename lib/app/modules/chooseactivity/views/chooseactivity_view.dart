import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/helper/responsive.dart';
import 'package:mandarinapp/app/widgets/CustomAppBar.dart';
import '../controllers/chooseactivity_controller.dart';

class ChooseactivityView extends GetView<ChooseactivityController> {
  const ChooseactivityView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.loadData();
    controller.getGamesProgress();
    controller.getQuizProgress();
    controller.getSwipeCardsProgress();
    controller.getGamesProgressText();
    controller.getQuizProgressText();
    controller.getSwipeCardsProgressText();
    return Scaffold(
      appBar: customAppBar(title: controller.categoryName.isNotEmpty ? controller.categoryName : (controller.activity ?? 'chooseactivity')),
      body: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'chooseactivity'.tr,
                    style: TextStyle(fontSize: Responsive.sp(context, 20), fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                  const SizedBox(height: 20),
                  
                  // Swipe Cards Activity
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: Responsive.isTablet(context) ? 14 : 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: Colors.white,
                    title: Text('swipecards'.tr, style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.w600)),
                    subtitle: Text(controller.getSwipeCardsProgressText(), style: TextStyle(fontSize: 14, color: primaryColor, fontWeight: FontWeight.w600)),
                    leading: Icon(Icons.card_giftcard_sharp, size: 35, color: primaryColor),
                    trailing: controller.getSwipeCardsProgress()?.isCompleted == true 
                        ? Icon(Icons.check_circle, color: Colors.green, size: 24)
                        : null,
                    onTap: controller.navigateToSwipeCards,
                  ),
                  const SizedBox(height: 10),
                  
                  // Take a Quiz Activity
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: Responsive.isTablet(context) ? 14 : 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: Colors.white,
                    title: Text('takeaquiz'.tr, style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.w600)),
                    subtitle: Text(controller.getQuizProgressText(), style: TextStyle(fontSize: 14, color: primaryColor, fontWeight: FontWeight.w600)),
                    leading: Icon(Icons.question_answer_outlined, size: 35, color: primaryColor),
                    trailing: controller.getQuizProgress()?.isCompleted == true 
                        ? Icon(Icons.check_circle, color: Colors.green, size: 24)
                        : null,
                    onTap: controller.navigateToQuiz,
                  ),
                  const SizedBox(height: 10),
                  
                  // Play Games Activity
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: Responsive.isTablet(context) ? 14 : 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: Colors.white,
                    title: Text('playgames'.tr, style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.w600)),
                    subtitle: Text(controller.getGamesProgressText(), style: TextStyle(fontSize: 14, color: primaryColor, fontWeight: FontWeight.w600)),
                    leading: Icon(Icons.gamepad, size: 35, color: primaryColor),
                    trailing: controller.getGamesProgressText() == '3/3'
                        ? Icon(Icons.check_circle, color: Colors.green, size: 24)
                        : null,
                    onTap: controller.navigateToGames,
                  ),
                ],
              ),
            )),
    );
  }
}
