import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/helper/responsive.dart';
import 'package:mandarinapp/app/routes/app_pages.dart';
import 'package:mandarinapp/app/widgets/CustomAppBar.dart';

import '../controllers/gamesselection_controller.dart';

class GamesselectionView extends GetView<GamesselectionController> {
  const GamesselectionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: controller.activity ?? 'gamesselection'),
      body: Padding(
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
                '0/10',
                style: TextStyle(
                  fontSize: 14,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: Icon(Icons.checklist_sharp, size: 35,),
              onTap: () {
                Get.toNamed(Routes.FILLBLANKS, arguments: {'activity': controller.activity});
              },
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
                '0/3',
                style: TextStyle(
                  fontSize: 14,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: Icon(Icons.circle_rounded, size: 35,),
              onTap: () {
                Get.toNamed(Routes.CHARACTERMATCHING, arguments: {'activity': controller.activity});
              },
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
                '0/3',
                style: TextStyle(
                  fontSize: 14,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: Icon(Icons.earbuds, size: 35,),
              onTap: () {
                Get.toNamed(Routes.LISTENING, arguments: {'activity': controller.activity});
              },
            ),
          ],
        ),
      ),
    );
  }
}
