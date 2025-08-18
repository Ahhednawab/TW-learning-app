import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/helper/responsive.dart';
import 'package:mandarinapp/app/routes/app_pages.dart';
import 'package:mandarinapp/app/widgets/CustomAppBar.dart';

import '../controllers/chooseactivity_controller.dart';

class ChooseactivityView extends GetView<ChooseactivityController> {
  const ChooseactivityView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title:controller.activity ?? 'chooseactivity'),
      body:Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'chooseactivity'.tr,
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
              title: Text('swipecards'.tr, style: TextStyle(fontSize: Responsive.sp(context, 18),fontWeight: FontWeight.w600)),
              subtitle: Text('0/10', style: TextStyle(fontSize: 14, color: primaryColor,fontWeight: FontWeight.w600)),
              leading: Icon(Icons.card_giftcard_sharp,size: 35,),
              onTap: () {   
                Get.toNamed(Routes.SWIPECARD,arguments: {'activity': controller.activity,});           
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
              title: Text('playgames'.tr, style: TextStyle(fontSize:  Responsive.sp(context, 18),fontWeight: FontWeight.w600)),
              subtitle: Text('0/3', style: TextStyle(fontSize: 14, color: primaryColor,fontWeight: FontWeight.w600)),
              leading: Icon(Icons.gamepad,size: 35,),            
              onTap: () {               
                Get.toNamed(Routes.GAMESSELECTION,arguments: {'activity': controller.activity,});
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
              title: Text('takeaquiz'.tr, style: TextStyle(fontSize:  Responsive.sp(context, 18),fontWeight: FontWeight.w600)),
              subtitle: Text('0/10', style: TextStyle(fontSize: 14, color: primaryColor,fontWeight: FontWeight.w600)),
              leading: Icon(Icons.question_answer_outlined,size: 35,),            
              onTap: () {   
                Get.toNamed(Routes.QUIZ,arguments: {'activity': controller.activity});
              },
            ),
          ],
        ),
      )
    );
  }
}
