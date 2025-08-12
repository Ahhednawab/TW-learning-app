import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';

class SuccessView extends GetView {
  const SuccessView({super.key});
  @override
  Widget build(BuildContext context) {
    // Get arguments from the navigation route
    final score = Get.arguments['score'] as double;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: secondaryColor,
        actions: [
          IconButton(
            onPressed: () {
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
              'Results of your practice!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
            ),
            SizedBox(height: 20),
            Stack(
              children: [
                Image.asset('assets/images/ticket.png', width: 300),
                Positioned(
                  bottom: 60,
                  right: 0,
                  left: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'You earned the badge',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      CircleAvatar(
                        backgroundColor: primaryColor,
                        radius: 30,
                        backgroundImage: AssetImage('assets/images/congrats.png'),
                      ),
                      
                      SizedBox(height: 5),
                      Text(
                        'Intermediate level unlocked',
                        style: TextStyle(fontSize: 12),
                      ),
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
                        'Congratulations! You \nhave scored',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),                      
                      SizedBox(height: 5),
                      Text(
                        '${score.toStringAsFixed(0)}%',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
