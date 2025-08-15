import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/widgets/CustomAppBar.dart';
import '../controllers/listening_controller.dart';
import 'package:mandarinapp/app/helper/responsive.dart';

class ListeningView extends GetView<ListeningController> {
  const ListeningView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController answerController = TextEditingController();

    return Scaffold(
      appBar: customAppBar(title: controller.activity ?? 'gamesselection'),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                child: Text(
                  'listening.animals'.tr,
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 18),
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Animal card
              Align(
                child: Obx(() {
                  final q = controller.questions[controller.currentIndex.value];
                  return SizedBox(
                    width: Responsive.wp(0.85),
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
                                q["image"]!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.playSound(q["audio"]!);
                                },
                                child: Container(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  child: Center(
                                    child: Icon(
                                      Icons.volume_up,
                                      color: Colors.white,
                                      size: Responsive.isTablet(context) ? 92 : 80,
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

              // Answer field
              Align(
                child: Obx(
                  () => SizedBox(
                    height: Responsive.isTablet(context) ? 48 : 44,
                    width: Responsive.wp(0.6),
                    child: TextFormField(
                      controller: answerController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: controller.textFieldColor.value,
                        hintText: 'answer'.tr,
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            controller.checkAnswer(answerController.text);
                            answerController.clear();
                          },
                          icon: const Icon(Icons.send, color: primaryColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

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

              // Correct answers text
              Obx(
                () => Text(
                  "correctanswers".tr+": ${controller.correctCount.value}/${controller.questions.length}",
                ),
              ),

              const SizedBox(height: 10),

              // Pass button
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  height: Responsive.isTablet(context) ? 40 : 34,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: whiteColor,
                      side: const BorderSide(color: primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      controller.nextQuestion();
                    },
                    child: Text(
                      'pass'.tr,
                      style: TextStyle(color: blackColor, fontSize: Responsive.sp(context, 14)),
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
