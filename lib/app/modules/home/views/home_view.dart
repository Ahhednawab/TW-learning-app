import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/widgets/HomeActionButton.dart';
import 'package:mandarinapp/app/widgets/HomeGreeting.dart';
import 'package:mandarinapp/app/widgets/HomeInfoCard.dart';
import 'package:mandarinapp/app/widgets/HomeProgressCard.dart';
import 'package:mandarinapp/app/widgets/HomeStreakCard.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: F,
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar, Language, Bell
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to profile
                        Get.toNamed('/profile');
                      },
                      child: const CircleAvatar(
                        radius: 24,
                        backgroundColor: primaryColor,
                        // child: Icon(Icons.person, color: whiteColor, size: 36),
                        backgroundImage: AssetImage(
                          'assets/images/profile.png',),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: GestureDetector(
                        onTap:() {
                          //Dropdown for language selection
                          
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Chinese',
                              style: TextStyle(
                                color: blackColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
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
                HomeGreeting(userName: 'John'),
                const SizedBox(height: 28),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HomeActionButton(
                      icon: Icons.menu_book_rounded,
                      label: 'New\nVocabulary',
                      onTap: () {},
                    ),
                    HomeActionButton(
                      icon: Icons.quiz_rounded,
                      label: 'Continue\nQuiz',
                      onTap: () {},
                    ),
                    HomeActionButton(
                      icon: Icons.style_rounded,
                      label: "Today's\nFlash Cards",
                      onTap: () {},
                    ),
                    HomeActionButton(
                      icon: Icons.translate_rounded,
                      label: 'Favourite\nWords',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Progress Card
                HomeProgressCard(
                  level: 'Beginner',
                  words: 3,
                  totalWords: 10,
                  onTap: () {},
                ),
                const SizedBox(height: 28),

                // Info Cards
                Row(
                  children: [
                    Expanded(
                      child: HomeInfoCard(
                        title: 'Word of the Day',
                        value: 'nǐ hǎo',
                        color: primaryColor,
                        watermark: '大',
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: HomeInfoCard(
                        title: 'Last word reviewed',
                        value: 'xiè xiè',
                        color: Color(0xFF6EC6C5),
                        watermark: '大',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: HomeInfoCard(
                        title: 'Time spend today',
                        value: '20 mins',
                        color: Color(0xFF9CA6F5),
                        watermark: '大',
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(child: SizedBox()),
                  ],
                ),
                const SizedBox(height: 28),

                // Streak Card
                HomeStreakCard(streakDays: 10, onTap: () {}),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
