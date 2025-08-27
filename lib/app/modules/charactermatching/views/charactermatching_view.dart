import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/helper/responsive.dart';
import 'package:mandarinapp/app/widgets/CustomAppBar.dart';
import '../controllers/charactermatching_controller.dart';

class CharactermatchingView extends GetView<CharactermatchingController> {
  const CharactermatchingView({super.key});
  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    return Scaffold(
      appBar: customAppBar(title: controller.categoryName),
      body: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : controller.gameRounds.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No words available for this category'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Get.back(),
                        child: Text('Go Back'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'Match the images with the correct Chinese characters',
                          style: TextStyle(
                            fontSize: Responsive.sp(context, isTablet ? 20 : 18),
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        // Image grid
                        Obx(() {
                          List<CharacterMatchingPair> currentRound = controller.currentRound;
                          if (currentRound.isEmpty) return SizedBox();
                          
                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                            ),
                            itemCount: currentRound.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 48 : 24,
                              vertical: isTablet ? 24 : 16,
                            ),
                            itemBuilder: (context, index) {
                              CharacterMatchingPair pair = currentRound[index];
                              bool isSelected = controller.selectedLeft.value == index;
                              bool isMatched = controller.revealed.length > index && controller.revealed[index];
                              
                              return GestureDetector(
                                onTap: () => controller.selectLeft(index),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected ? primaryColor.withOpacity(0.3) : whiteColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected ? primaryColor : Colors.transparent,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Stack(
                                      children: [
                                        pair.imageUrl.isNotEmpty
                                            ? Image.network(
                                                pair.imageUrl,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(
                                                    color: primaryColor.withOpacity(0.1),
                                                    child: Icon(
                                                      Icons.image_not_supported,
                                                      size: 48,
                                                      color: primaryColor,
                                                    ),
                                                  );
                                                },
                                              )
                                            : Container(
                                                color: primaryColor.withOpacity(0.1),
                                                child: Icon(
                                                  Icons.image,
                                                  size: 48,
                                                  color: primaryColor,
                                                ),
                                              ),
                                        if (!isMatched)
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.8),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.question_mark,
                                                size: isTablet ? 88 : 72,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        if (isMatched)
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.green.withOpacity(0.3),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.check_circle,
                                                size: isTablet ? 88 : 72,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                        const SizedBox(height: 20),
                        // Character selection
                        Obx(() {
                          List<CharacterMatchingPair> currentRound = controller.currentRound;
                          if (currentRound.isEmpty) return SizedBox();
                          
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Left column (Chinese Characters)
                              Column(
                                children: List.generate(currentRound.length, (i) {
                                  bool isSelected = controller.selectedRight.value == i;
                                  bool isMatched = controller.revealed.length > i && controller.revealed[i];
                                  Color bg = whiteColor;
                                  
                                  if (isMatched) {
                                    bg = Colors.green[200]!;
                                  } else if (isSelected) {
                                    bg = primaryColor.withOpacity(0.3);
                                  }
                                  
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: ChoiceChip(
                                      label: Text(
                                        currentRound[i].traditional,
                                        style: TextStyle(
                                          fontSize: Responsive.sp(context, isTablet ? 18 : 16),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      selected: isSelected,
                                      backgroundColor: bg,
                                      selectedColor: bg,
                                      side: BorderSide.none,
                                      onSelected: isMatched ? null : (val) {
                                        controller.selectRight(i);
                                      },
                                    ),
                                  );
                                }),
                              ),
                              // Right column (English)
                              Column(
                                children: List.generate(currentRound.length, (i) {
                                  bool isMatched = controller.revealed.length > i && controller.revealed[i];
                                  
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 11),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isMatched ? Colors.green[100] : Colors.grey[200],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        currentRound[i].english,
                                        style: TextStyle(
                                          fontSize: Responsive.sp(context, isTablet ? 16 : 14),
                                          color: isMatched ? Colors.green[800] : Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 20),
                        // Progress bar
                        Obx(() => LinearProgressIndicator(
                              value: controller.progress.value,
                              backgroundColor: primaryColor.withOpacity(0.4),
                              color: primaryColor,
                              minHeight: 5,
                            )),
                        const SizedBox(height: 10),
                        Obx(
                          () => Text(
                            "Round: ${controller.currentIndex.value + 1}/${controller.gameRounds.length} | Score: ${controller.score.value}",
                            style: TextStyle(fontSize: Responsive.sp(context, isTablet ? 16 : 14)),
                          ),
                        ),
                        SizedBox(height: 10),
                        // Pass button
                        Align(
                          alignment: Alignment.bottomRight,
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
                      ],
                    ),
                  ),
                )),
    );
  }
}
