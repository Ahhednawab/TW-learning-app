import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/swipecard_controller.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/widgets/CustomAppBar.dart';
import 'package:mandarinapp/app/helper/responsive.dart';

class SwipecardView extends GetView<SwipecardController> {
  const SwipecardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: controller.categoryName.isNotEmpty ? controller.categoryName : 'Swipe Cards'),
      body: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : controller.words.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No words available',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 6),
                        Text(
                          controller.categoryName.tr,
                          style: TextStyle(
                            fontSize: Responsive.sp(context, 18),
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                    
                        // Animated Swipe Card
                        Obx(() {
                          if (controller.currentIndex.value >= controller.words.length) {
                            return SizedBox.shrink();
                          }
                          final word = controller.words[controller.currentIndex.value];
                          return SlideTransition(
                  position: controller.swipeAnimation,
                  child: SizedBox(
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
                          word.imageUrl.isNotEmpty
                              ? Image.network(
                                  word.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/placeholder.png',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/images/placeholder.png',
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
                                    height: Responsive.isTablet(context) ? 320 : 150,
                                    padding: EdgeInsets.all(Responsive.isTablet(context) ? 36 : 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  word.traditional,
                                                  style: TextStyle(
                                                    fontSize: Responsive.isTablet(context) ? 40 : 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  word.pinyin,
                                                  style: TextStyle(
                                                    fontSize: Responsive.isTablet(context) ? 20 : 14,
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: controller.playWordAudio,
                                                  child: Icon(
                                                    Icons.volume_up,
                                                    color: Colors.white,
                                                    size: Responsive.isTablet(context) ? 36 : 22,
                                                  ),
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
                                                      size: Responsive.isTablet(context) ? 34 : 22,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "${word.partOfSpeech} • ${word.english}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Responsive.isTablet(context) ? 18 : 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          word.exampleSentence.english,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: Responsive.isTablet(context) ? 16 : 12,
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
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          word.traditional,
                                          style: TextStyle(
                                            fontSize: Responsive.isTablet(context) ? 40 : 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          word.pinyin,
                                          style: TextStyle(
                                            fontSize: Responsive.isTablet(context) ? 20 : 14,
                                            color: Colors.white70,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                          }),
                            ],
                          ),
                        ),
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
                                    height: Responsive.isTablet(context) ? 58 : 40,
                                    width: Responsive.isTablet(context) ? 58 : 40,
                                  ),
                                  onPressed: controller.markLearn,
                                ),
                                Text('no'.tr, style: TextStyle(fontSize: Responsive.sp(context, 18),fontWeight: FontWeight.bold,)),
                              ],
                            ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'doyouknow'.tr,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.sp(context, 22),
                        ),
                      ),
                    ),
                  ),                  
                  Column(
                    children: [
                      IconButton(
                        icon: Image.asset(
                          'assets/images/right.png',
                          height: Responsive.isTablet(context) ? 58 : 40,
                          width: Responsive.isTablet(context) ? 58 : 40,
                        ),
                        onPressed: controller.markKnown,
                      ),
                      Text('yes'.tr, style: TextStyle(fontSize: Responsive.sp(context, 18),fontWeight: FontWeight.bold,)),
                    ],
                  ),
                ],
              ),
          
                        const SizedBox(height: 20),
                    
                        // Progress
                        Obx(
                          () => LinearProgressIndicator(
                            value: controller.progress.value,
                            backgroundColor: primaryColor.withOpacity(0.4),
                            color: primaryColor,
                            minHeight: 5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Obx(
                          () => Text(
                            "words".tr+": ${controller.currentIndex.value + 1}/${controller.words.length}",
                            style: TextStyle(fontSize: Responsive.sp(context, 18)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
    );
  }
}
