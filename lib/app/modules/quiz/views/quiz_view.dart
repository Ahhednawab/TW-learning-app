import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/helper/responsive.dart';
import 'package:mandarinapp/app/widgets/CustomAppBar.dart';
import '../controllers/quiz_controller.dart';

class QuizView extends GetView<QuizController> {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    return Scaffold(
      appBar: customAppBar(title: 'quiz'),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
          
              // Question Card
              Align(
                child: Obx(() {
                  final question = controller.questions[controller.currentIndex.value];
                  final double cardMaxWidth = Responsive.wp(isTablet ? 0.6 : 0.85);
                  return SizedBox(
                    width: cardMaxWidth,
                    child: AspectRatio(
                      aspectRatio: 4 / 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              Image.asset(
                                question.image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              Container(
                                color: Colors.black.withValues(alpha: 0.6),
                                padding: const EdgeInsets.all(12),
                                child: Center(
                                  child: SizedBox(
                                    width: Responsive.clamp(cardMaxWidth * 0.6, min: 160, max: 360),
                                    child: Text(
                                      question.description,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Responsive.sp(context, isTablet ? 16 : 14),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
          
              const SizedBox(height: 20),
          
              // Options
              Obx(() {
                final question = controller.questions[controller.currentIndex.value];
                return Column(
                  children: List.generate(2, (row) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(2, (col) {
                          int optionIndex = row * 2 + col;
                          String optionText = question.options[optionIndex];
                          Color? bgColor = controller.answerColor[optionIndex];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GestureDetector(
                              onTap: () => controller.selectOption(optionIndex),
                              child: Chip(
                                label: Text(
                                  optionText,
                                  style: TextStyle(
                                    height: 2.5,
                                    fontSize: Responsive.sp(context, isTablet ? 16 : 14),
                                  ),
                                ),
                                backgroundColor: bgColor ?? whiteColor,
                                shape: const RoundedRectangleBorder(),
                                side: BorderSide.none,
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                );
              }),
          
              const SizedBox(height: 10),
          
              // Progress bar
              Obx(() => LinearProgressIndicator(
                    value: controller.progress.value,
                    backgroundColor: primaryColor.withValues(alpha: 0.4),
                    color: primaryColor,
                    minHeight: 5,
                  )),
          
              const SizedBox(height: 10),
          
              // Score
              Obx(() => Text(
                    "correctanswers".tr+": ${controller.correctCount.value}/${controller.questions.length}",
                    style: TextStyle(fontSize: Responsive.sp(context, isTablet ? 16 : 14)),
                  )),
          
              const SizedBox(height: 10),
          
              // Pass button
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: whiteColor,
                      side: const BorderSide(color: primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: controller.passQuestion,
                    child: Text(
                      'pass'.tr,
                      style: TextStyle(
                        color: blackColor,
                        fontSize: Responsive.sp(context, isTablet ? 16 : 14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
