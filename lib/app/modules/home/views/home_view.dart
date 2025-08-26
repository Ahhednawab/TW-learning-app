import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/modules/bottomnav/controllers/bottomnav_controller.dart';
import 'package:mandarinapp/app/services/Localization.dart';
import 'package:mandarinapp/app/widgets/HomeActionButton.dart';
import 'package:mandarinapp/app/widgets/HomeGreeting.dart';
import 'package:mandarinapp/app/widgets/HomeInfoCard.dart';
import 'package:mandarinapp/app/widgets/HomeProgressCard.dart';
import 'package:mandarinapp/app/widgets/HomeStreakCard.dart';
import '../controllers/home_controller.dart';
import 'package:mandarinapp/app/helper/responsive.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.wp(0.055),
              vertical: 18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar, Language, Bell
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to profile
                        Get.find<BottomnavController>().changeTabIndex(3);
                      },
                      child: const CircleAvatar(
                        radius: 24,
                        backgroundColor: primaryColor,
                        // child: Icon(Icons.person, color: whiteColor, size: 36),
                        backgroundImage: AssetImage(
                          'assets/images/profile.png',
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Center(
                        child: PopupMenuButton<String>(
                          color: whiteColor,
                          menuPadding: EdgeInsets.zero,
                          borderRadius: BorderRadius.circular(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onSelected: (value) {
                            // Handle language selection logic here
                            print('Selected language: $value');
                            // You can update state or use GetX controller here if needed
                            // controller.selectedLanguage!.value = value;
                            Get.find<LocalizationController>().setLanguage(Locale(value));
                            controller.selectedLanguage?.value = value;
                          },
                          itemBuilder:
                              (context) =>
                                  controller.languages.map((language) {
                                    return PopupMenuItem(
                                      height: 40,
                                      value: language,
                                      child: Text(language.tr),
                                    );
                                  }).toList(),

                          offset: const Offset(-6, 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(
                                () => Text(
                                  controller.selectedLanguage?.value.tr ?? '',
                                  style: TextStyle(
                                    color: blackColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Responsive.sp(context, 17),
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: blackColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: blackColor,
                        size: 28,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                // Greeting
                Obx(() => HomeGreeting(userName: controller.userName)),
                const SizedBox(height: 28),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HomeActionButton(
                      icon: Icons.menu_book_rounded,
                      label: 'newvocabulary'.tr,
                      onTap: () {
                        Get.find<BottomnavController>().changeTabIndex(1);
                      },
                    ),
                    HomeActionButton(
                      icon: Icons.quiz_rounded,
                      label: 'continuequiz'.tr,
                      onTap: () {
                        controller.continuePreviousQuiz();
                      },
                    ),
                    HomeActionButton(
                      icon: Icons.style_rounded,
                      label: "todaysflashcards".tr,
                      onTap: () {
                        Get.find<BottomnavController>().changeTabIndex(1);
                      },
                    ),
                    HomeActionButton(
                      icon: Icons.translate_rounded,
                      label: 'favoritewords'.tr,
                      onTap: () {
                        controller.navigateToFavorites();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Progress Card
                Obx(() => controller.isLoading.value
                    ? Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: greyColor.withValues(alpha:0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : HomeProgressCard(
                        level: controller.currentLevelText,
                        words: controller.wordsLearned.value,
                        totalWords: controller.totalWords.value,
                        onTap: () {
                          controller.navigateToVocabulary();
                        },
                      ),
                ),
                const SizedBox(height: 28),

                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Left side: Word of the Day (tall card)
                      Expanded(
                        flex: 1,
                        child: Obx(() => HomeInfoCard(
                          title: 'wordofday',
                          value: controller.wordOfTheDayText,
                          color: primaryColor,
                          watermark: '大',
                        )),
                      ),
                      const SizedBox(width: 5),

                      // Right side: Two stacked cards
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            SizedBox(
                              // height: 126,
                              width: double.infinity,
                              child: Obx(() => HomeInfoCard(
                                title: 'lastwordreviewed',
                                value: controller.lastWordReviewedText,
                                color: const Color(0xFF6EC6C5),
                                watermark: '大',
                              )),
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              // height: 126,
                              width: double.infinity,
                              child: Obx(() => HomeInfoCard(
                                title: 'timespenttoday',
                                value: controller.timeSpentTodayText,
                                color: const Color(0xFF9CA6F5),
                                watermark: '大',
                              )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),


                SizedBox(height: 28),
                // Streak Card
                Obx(() => HomeStreakCard(
                  streakDays: controller.currentStreak.value,
                  onTap: () {
                    controller.navigateToVocabulary();
                  },
                )),
                const SizedBox(height: 28),
                // Advertise Card 
                Container(
                  height: Responsive.hp(0.1),
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                  color: greyColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'advertise'.tr,
                      style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                        fontSize: Responsive.sp(Get.context!, 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
