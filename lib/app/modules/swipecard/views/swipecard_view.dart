import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/swipecard_controller.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/widgets/CustomAppBar.dart';

class SwipecardView extends GetView<SwipecardController> {
  const SwipecardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: controller.title ?? 'Beginner'),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(height: 6),
            Text(
              "Animals",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 20),

            // Animated Swipe Card
            Obx(() {
              final word = controller.words[controller.currentIndex.value];
              return SlideTransition(
                position: controller.swipeAnimation,
                child: Container(
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
                          word.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),

                        // Overlay animation for Learn mode
                        GetBuilder<SwipecardController>(
                          builder: (controller) {
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: SizeTransition(
                                sizeFactor: controller.overlayAnimation,
                                axis: Axis.vertical,
                                axisAlignment: -1,
                                child: Container(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            word.word,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.volume_up,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 10),
                                              Obx(
                                                () => GestureDetector(
                                                  onTap: controller.toggleLike,
                                                  child: Icon(
                                                    controller.isLiked.value
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: controller.isLiked.value ? Colors.red : Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${word.type} • ${word.meaning}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        word.example,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // Word text at bottom if not learning
                        Obx(() {
                          return controller.isLearning.value
                              ? const SizedBox()
                              : Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.black.withValues(alpha: 0.6),
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    word.word,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                        }),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/images/left.png',
                        height: 40,
                        width: 40,
                      ),
                      onPressed: controller.markKnown,
                    ),
                    const Text('Known'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/images/right.png',
                        height: 40,
                        width: 40,
                      ),
                      onPressed: controller.markLearn,
                    ),
                    const Text('Learn'),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Progress
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
                "Words: ${controller.currentIndex.value + 1}/${controller.words.length}",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
