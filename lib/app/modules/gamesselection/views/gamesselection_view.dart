import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: Colors.white,
              title: Text(
                'fillblanks'.tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '0/10',
                style: TextStyle(
                  fontSize: 14,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: Icon(Icons.checklist_sharp),
              onTap: () {
                Get.toNamed(Routes.FILLBLANKS, arguments: {'activity': controller.activity});
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: Colors.white,
              title: Text(
                'charactermatching'.tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '0/3',
                style: TextStyle(
                  fontSize: 14,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: Icon(Icons.circle_rounded),
              onTap: () {
                Get.toNamed(Routes.CHARACTERMATCHING, arguments: {'activity': controller.activity});
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: Colors.white,
              title: Text(
                'listening'.tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '0/3',
                style: TextStyle(
                  fontSize: 14,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: Icon(Icons.earbuds),
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
