import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/widgets/CustomAppBar.dart';
import '../controllers/quiz_controller.dart';

class QuizView extends GetView<QuizController> {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'quiz'),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Question Card
            Align(
              child: Obx(() {
                final question = controller.questions[controller.currentIndex.value];
                return Container(
                  height: 380,
                  width: 300,
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
                              width: 180,
                              child: Text(
                                question.description,
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                                style: const TextStyle(height: 2.5),
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
                )),

            const SizedBox(height: 10),

            // Pass button
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: 30,
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
                    style: TextStyle(color: blackColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
