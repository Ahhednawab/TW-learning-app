import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/helper/responsive.dart';
import 'package:mandarinapp/app/modules/chooseactivity/controllers/chooseactivity_controller.dart';

class QuizFailureView extends GetView {
  const QuizFailureView({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Get arguments from the navigation route
    int score = 0;
    int correctAnswers = 0;
    try {
      score = Get.arguments['score'] as int;
      correctAnswers = Get.arguments['correctAnswers'] as int;
    } catch (e) {
      print("Error retrieving score: $e");
    }
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red[400],
        actions: [
          IconButton(
            onPressed: () {
              Get.back();
                // Refresh games selection screen
                try {
                  final controller = Get.find<ChooseactivityController>();
                  controller.refreshData();
                } catch (e) {
                  print('Games selection controller not found: $e');
                }
            },
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz Results',
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
                        'Try Again!',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 18),
                          fontWeight: FontWeight.bold,
                          color: Colors.red[600],
                        ),
                      ),
                      SizedBox(height: 5),
                      CircleAvatar(
                        backgroundColor: Colors.red[400],
                        radius: Responsive.isTablet(context) ? 34 : 30,
                        child: Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: Responsive.isTablet(context) ? 40 : 30,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Need 80% to pass',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 12),
                          color: Colors.red[600],
                        ),
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
                        'Keep Practicing!',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 18),
                          fontWeight: FontWeight.bold,
                          color: Colors.red[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'You got $correctAnswers out of ${Get.arguments['totalQuestions'] ?? 10} \ncorrect answers',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 16),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text(
                        '$score%',
                        style: TextStyle(
                          fontSize: Responsive.isTablet(context) ? 42 : 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Get.back();
                // Refresh games selection screen
                try {
                  final controller = Get.find<ChooseactivityController>();
                  controller.refreshData();
                } catch (e) {
                  print('Games selection controller not found: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                'Try Again',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Responsive.sp(context, 16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
