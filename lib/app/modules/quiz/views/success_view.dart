import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/helper/responsive.dart';
import 'package:mandarinapp/app/modules/chooseactivity/controllers/chooseactivity_controller.dart';

class SuccessView extends GetView {
  const SuccessView({super.key});
  @override
  Widget build(BuildContext context) {
    // Get arguments from the navigation route
    final score = Get.arguments['score'] as int;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: secondaryColor,
        actions: [
          IconButton(
            onPressed: () {
              // Refresh games selection screen
              try {
                final controller2 = Get.find<ChooseactivityController>();
                controller2.refreshData();
              } catch (e) {
                print('Choose activity controller not found: $e');
              }
              Get.back();
            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'practiceresults'.tr,
              style: TextStyle(fontSize: Responsive.sp(context, 24), fontWeight: FontWeight.bold,),
            ),
            SizedBox(height: 20),
            Stack(
              children: [
                Image.asset('assets/images/ticket.png', width: Responsive.wp(0.75)),
                Positioned(
                  bottom: 60,
                  right: 0,
                  left: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'badgeearned'.tr,
                        style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 15),
                      CircleAvatar(
                        backgroundColor: primaryColor,
                        radius: Responsive.isTablet(context) ? 34 : 30,
                        backgroundImage: AssetImage('assets/images/congrats.png'),
                      ),
                      
                    //   SizedBox(height: 5),
                    //   Text(
                    //     'imu'.tr,
                    //     style: TextStyle(fontSize: Responsive.sp(context, 12)),
                    //   ),
                    ],
                  )
                ),
                Positioned(
                  top: 60,
                  right: 0,
                  left: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'scored'.tr,
                        style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),                      
                      SizedBox(height: 5),
                      Text(
                        '${score.toStringAsFixed(0)}%',
                        style: TextStyle(fontSize: Responsive.sp(context, 22), fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}
