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
    return Scaffold(
      appBar: customAppBar(title: controller.categoryName),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.questions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No questions available',
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 18),
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          );
        }

        final question = controller.questions[controller.currentIndex.value];

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Progress bar
              LinearProgressIndicator(
                value: controller.progress.value,
                backgroundColor: primaryColor.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
                minHeight: 6,
              ),
              const SizedBox(height: 10),

              // Progress text
              Text(
                'Question ${controller.currentIndex.value + 1} of ${controller.questions.length}',
                style: TextStyle(
                  fontSize: Responsive.sp(context, 14),
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),

              // Image with audio button
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        // Image
                        if (question.imageUrl.isNotEmpty)
                          Image.network(
                            question.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                        else
                          Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.image,
                              size: 64,
                              color: Colors.grey,
                            ),
                          ),

                        // Audio button overlay
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: controller.playAudio,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    controller.isPlaying.value 
                                        ? Icons.volume_up 
                                        : Icons.play_arrow,
                                    size: 40,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Instructions
              Text(
                'Listen and select the correct English translation:',
                style: TextStyle(
                  fontSize: Responsive.sp(context, 16),
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Answer options
              Expanded(
                flex: 2,
                child: ListView.builder(
                  itemCount: question.options.length,
                  itemBuilder: (context, index) {
                    Color? backgroundColor;
                    if (controller.answerColor.containsKey(index)) {
                      backgroundColor = controller.answerColor[index];
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: backgroundColor ?? whiteColor,
                            side: BorderSide(
                              color: backgroundColor != null 
                                  ? Colors.transparent 
                                  : primaryColor.withValues(alpha: 0.3),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: backgroundColor != null ? 0 : 1,
                          ),
                          onPressed: controller.selectedOption.value == -1
                              ? () => controller.selectOption(index)
                              : null,
                          child: Text(
                            question.options[index],
                            style: TextStyle(
                              fontSize: Responsive.sp(context, 16),
                              color: backgroundColor != null 
                                  ? Colors.black87 
                                  : primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Score and pass button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Score: ${controller.score.value}/${controller.questions.length}',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 16),
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      side: BorderSide(color: Colors.grey[400]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: controller.selectedOption.value == -1
                        ? controller.passQuestion
                        : null,
                    child: Text(
                      'Pass',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: Responsive.sp(context, 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
