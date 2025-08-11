import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/widgets/CustomAppBar.dart';
import '../controllers/fillblanks_controller.dart';

class FillblanksView extends GetView<FillblanksController> {
  const FillblanksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: controller.activity ?? 'Fill in the blanks'),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            const Text(
              'Fill in the blanks - Animals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 20),

            // Animated Image
            Obx(() {
              final question =
                  controller.questions[controller.currentIndex.value];
              return SlideTransition(
                position: controller.swipeAnimation,
                child: Container(
                  height: 320,
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
                    child: Image.asset(question.image, fit: BoxFit.cover),
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // Question & Options
            Obx(() {
              final question =
                  controller.questions[controller.currentIndex.value];
              return Column(
                children: [
                  Text(question.questionText, textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Column(
                    children: List.generate(2, (row) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(2, (col) {
                            int optionIndex = row * 2 + col;
                            String optionText = question.options[optionIndex];
                            Color? bgColor =
                                controller.answerColor[optionIndex];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: GestureDetector(
                                onTap:
                                    () => controller.selectOption(optionIndex),
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
                  ),
                ],
              );
            }),

            const SizedBox(height: 10),

            // Progress bar
            Obx(
              () => LinearProgressIndicator(
                value: controller.progress.value,
                backgroundColor: primaryColor.withValues(alpha: 0.4),
                color: primaryColor,
                minHeight: 5,
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => Text(
                "Correct Answers: ${controller.currentIndex.value}/${controller.questions.length}",
              ),
            ),
            SizedBox(height: 10),
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
                  child: const Text(
                    'Pass',
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
