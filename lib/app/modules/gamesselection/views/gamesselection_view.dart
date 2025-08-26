import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/helper/responsive.dart';
import 'package:mandarinapp/app/widgets/CustomAppBar.dart';
import '../controllers/gamesselection_controller.dart';

class GamesselectionView extends GetView<GamesselectionController> {
  const GamesselectionView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.loadGameData();
    controller.getFillBlanksProgress();
    controller.getCharacterMatchingProgress();
    controller.getListeningProgress();
    controller.getFIBProgressText();
    controller.getCMText();
    controller.getListeningText();
    return Scaffold(
      appBar: customAppBar(title: controller.categoryName.isNotEmpty ? controller.categoryName : 'Games'),
      body: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'choosegame'.tr,
                    style: TextStyle(fontSize: Responsive.sp(context, 20),fontWeight: FontWeight.bold,color: primaryColor),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: Responsive.isTablet(context) ? 14 : 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: Colors.white,
                    title: Text(
                      'fillblanks'.tr,
                      style: TextStyle(fontSize: Responsive.sp(context, 18),fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      controller.getFIBProgressText(),
                      style: TextStyle(
                        fontSize: 14,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: controller.getFillBlanksProgress()?.isCompleted == true 
                        ? Icon(Icons.check_circle, color: Colors.green, size: 24)
                        : null,
                    leading: Icon(Icons.checklist_sharp, size: 35,),
                    onTap: controller.navigateToFillBlanks,
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: Responsive.isTablet(context) ? 14 : 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: Colors.white,
                    title: Text(
                      'charactermatching'.tr,
                      style: TextStyle(fontSize: Responsive.sp(context, 18),fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      controller.getCMText(),
                      style: TextStyle(
                        fontSize: 14,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: controller.getCharacterMatchingProgress()?.isCompleted == true 
                        ? Icon(Icons.check_circle, color: Colors.green, size: 24)
                        : null,
                    leading: Icon(Icons.circle_rounded, size: 35,),
                    onTap: controller.navigateToCharacterMatching,
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: Responsive.isTablet(context) ? 14 : 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: Colors.white,
                    title: Text(
                      'listening'.tr,
                      style: TextStyle(fontSize:  Responsive.sp(context, 18),fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      controller.getListeningText(),
                      style: TextStyle(
                        fontSize: 14,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    leading: Icon(Icons.earbuds, size: 35,),
                    trailing: controller.getListeningProgress()?.isCompleted == true
                        ? Icon(Icons.check_circle, color: Colors.green, size: 24)
                        : null,
                    onTap: controller.navigateToListening,
                  ),
                ],
              ),
            )),
    );
  }
}
