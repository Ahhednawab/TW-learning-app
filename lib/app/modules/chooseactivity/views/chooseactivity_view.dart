import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/routes/app_pages.dart';
import 'package:mandarinapp/app/widgets/CustomAppBar.dart';

import '../controllers/chooseactivity_controller.dart';

class ChooseactivityView extends GetView<ChooseactivityController> {
  const ChooseactivityView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title:controller.activity ?? 'Choose Activity'),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: primaryColor),
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
              title: Text('Swipe Cards', style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600)),
              subtitle: Text('0/20', style: TextStyle(fontSize: 14, color: primaryColor,fontWeight: FontWeight.w600)),
              leading: Icon(Icons.card_giftcard_sharp,),            
              onTap: () {   
                Get.toNamed(Routes.SWIPECARD,arguments: {'activity': controller.activity,});           
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
              title: Text('Play Games', style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600)),
              subtitle: Text('0/20', style: TextStyle(fontSize: 14, color: primaryColor,fontWeight: FontWeight.w600)),
              leading: Icon(Icons.gamepad,),            
              onTap: () {               
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
              title: Text('Take a Quiz', style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600)),
              subtitle: Text('0/20', style: TextStyle(fontSize: 14, color: primaryColor,fontWeight: FontWeight.w600)),
              leading: Icon(Icons.question_answer_outlined,),            
              onTap: () {               
              },
            ),
          ],
        ),
      )
    );
  }
}
