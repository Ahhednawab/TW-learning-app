import 'package:cached_network_image/cached_network_image.dart';
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
      body: Obx(
        () =>
            controller.isLoading.value
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
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'Match the Chinese characters with their English translations',
                          style: TextStyle(
                            fontSize: Responsive.sp(
                              context,
                              isTablet ? 20 : 18,
                            ),
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // Image grid (non-interactive, just for display)
                        Obx(() {
                          List<CharacterMatchingPair> currentRound =
                              controller.currentRound;
                          if (currentRound.isEmpty) return SizedBox();

                          return // Image grid (non-interactive, just for display)
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                ),
                            itemCount: controller.currentRound.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 40 : 20,
                            ),
                            itemBuilder: (context, index) {
                              CharacterMatchingPair pair =
                                  controller.currentRound[index];

                              return Obx(() {
                                // WRAP EACH ITEM IN Obx
                                bool isRevealed =
                                    controller.revealed.length > index &&
                                    controller.revealed[index];

                                return Container(
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withValues(alpha: 0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Stack(
                                      children: [
                                        // Image
                                        pair.imageUrl.isNotEmpty
                                            ? CachedNetworkImage(
                                              imageUrl: pair.imageUrl,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                              errorWidget: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return Container(
                                                  color: primaryColor
                                                      .withValues(alpha: 0.1),
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    size: 40,
                                                    color: primaryColor,
                                                  ),
                                                );
                                              },
                                            )
                                            : Container(
                                              color: primaryColor.withValues(alpha: 0.1),
                                              child: Icon(
                                                Icons.image,
                                                size: 40,
                                                color: primaryColor,
                                              ),
                                            ),

                                        // Overlay for unrevealed items
                                        if (!isRevealed)
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: 0.9),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.question_mark,
                                                size: isTablet ? 60 : 50,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),

                                        // Success overlay for revealed items
                                        if (isRevealed)
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.green.withValues(alpha: 0.2),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.check_circle,
                                                size: isTablet ? 60 : 50,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }); // END Obx
                            },
                          );
                        }),

                        const SizedBox(height: 10),

                        // Matching columns
                        Obx(() {
                          if (controller.chineseOptions.isEmpty ||
                              controller.englishOptions.isEmpty) {
                            return SizedBox();
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left column - Chinese characters
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'Chinese',
                                      style: TextStyle(
                                        fontSize: Responsive.sp(context, 16),
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    ...List.generate(
                                      controller.chineseOptions.length,
                                      (index) {
                                        bool isSelected =
                                            controller.selectedChinese.value ==
                                            index;
                                        bool isMatched = controller.matchedPairs
                                            .contains(index);
                                        bool isWrongSelection =
                                            controller
                                                .wrongAnswerFeedback
                                                .value &&
                                            controller
                                                    .wrongChineseIndex
                                                    .value ==
                                                index;

                                        Color backgroundColor = whiteColor;
                                        Color textColor = Colors.black;
                                        Color borderColor = Colors.grey[300]!;

                                        if (isMatched) {
                                          backgroundColor = Colors.green[100]!;
                                          borderColor = Colors.green;
                                          textColor = Colors.green[800]!;
                                        } else if (isWrongSelection) {
                                          backgroundColor = Colors.red[100]!;
                                          borderColor = Colors.red;
                                          textColor = Colors.red[800]!;
                                        } else if (isSelected) {
                                          backgroundColor = primaryColor
                                              .withValues(alpha: 0.1);
                                          borderColor = primaryColor;
                                          textColor = primaryColor;
                                        }

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                          ),
                                          child: GestureDetector(
                                            onTap:
                                                () => controller.selectChinese(
                                                  index,
                                                ),
                                            child: Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 12,
                                                horizontal: 16,
                                              ),
                                              decoration: BoxDecoration(
                                                color: backgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: borderColor,
                                                  width: 2,
                                                ),
                                              ),
                                              child: Text(
                                                controller
                                                    .chineseOptions[index],
                                                style: TextStyle(
                                                  fontSize: Responsive.sp(
                                                    context,
                                                    isTablet ? 18 : 14,
                                                  ),
                                                  color: textColor,
                                                  fontWeight:
                                                      isSelected || isMatched
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(width: 20),

                              // Right column - English translations
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'English',
                                      style: TextStyle(
                                        fontSize: Responsive.sp(context, 16),
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    ...List.generate(
                                      controller.englishOptions.length,
                                      (index) {
                                        bool isSelected =
                                            controller.selectedEnglish.value ==
                                            index;
                                        bool isMatched = controller
                                            .isEnglishMatched(index);
                                        bool isWrongSelection =
                                            controller
                                                .wrongAnswerFeedback
                                                .value &&
                                            controller
                                                    .wrongEnglishIndex
                                                    .value ==
                                                index;

                                        Color backgroundColor = whiteColor;
                                        Color textColor = Colors.black;
                                        Color borderColor = Colors.grey[300]!;

                                        if (isMatched) {
                                          backgroundColor = Colors.green[100]!;
                                          borderColor = Colors.green;
                                          textColor = Colors.green[800]!;
                                        } else if (isWrongSelection) {
                                          backgroundColor = Colors.red[100]!;
                                          borderColor = Colors.red;
                                          textColor = Colors.red[800]!;
                                        } else if (isSelected) {
                                          backgroundColor = primaryColor
                                              .withValues(alpha: 0.1);
                                          borderColor = primaryColor;
                                          textColor = primaryColor;
                                        }

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                          ),
                                          child: GestureDetector(
                                            onTap:
                                                () => controller.selectEnglish(
                                                  index,
                                                ),
                                            child: Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 12,
                                                horizontal: 16,
                                              ),
                                              decoration: BoxDecoration(
                                                color: backgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: borderColor,
                                                  width: 2,
                                                ),
                                              ),
                                              child: Text(
                                                controller
                                                    .englishOptions[index],
                                                style: TextStyle(
                                                  fontSize: Responsive.sp(
                                                    context,
                                                    isTablet ? 16 : 14,
                                                  ),
                                                  color: textColor,
                                                  fontWeight:
                                                      isSelected || isMatched
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),

                        const SizedBox(height: 30),

                        // Progress bar
                        Obx(
                          () => LinearProgressIndicator(
                            value: controller.progress.value,
                            backgroundColor: primaryColor.withValues(alpha: 0.4),
                            color: primaryColor,
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Score and round info
                        Obx(
                          () => Text(
                            "Round: ${controller.currentIndex.value + 1}/${controller.gameRounds.length} | Score: ${controller.score.value}",
                            style: TextStyle(
                              fontSize: Responsive.sp(
                                context,
                                isTablet ? 16 : 14,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        SizedBox(height: 15),

                        // Pass button
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: whiteColor,
                              side: const BorderSide(color: primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                            ),
                            onPressed: controller.passQuestion,
                            child: Text(
                              'Pass',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: Responsive.sp(
                                  context,
                                  isTablet ? 16 : 14,
                                ),
                                fontWeight: FontWeight.w500,
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
  }
}
