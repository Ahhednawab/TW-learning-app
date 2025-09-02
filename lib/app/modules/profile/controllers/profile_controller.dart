import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/models/user_model.dart';
import 'package:mandarinapp/app/modules/home/controllers/home_controller.dart';
import 'package:mandarinapp/app/services/Snackbarservice.dart';
import 'package:mandarinapp/app/services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  // Observable variables
  var isLoading = true.obs;
  var isNotificationEnabled = true.obs;
  var selectedLanguage = 'en'.obs;
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  
  // User statistics
  var totalWordsLearned = 0.obs;
  var totalQuizzesTaken = 0.obs;
  var totalGamesCompleted = 0.obs;
  var favoriteWordsCount = 0.obs;
  var currentStreak = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
    loadUserStatistics();
    loadSettings();
  }

  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      String? userId = FirebaseService.currentUserId;
      if (userId != null) {
        UserModel? user = await FirebaseService.getUserData(userId);
        currentUser.value = user;
      }
    } catch (e) {
      print('Error loading user profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadUserStatistics() async {
    try {
      String? userId = FirebaseService.currentUserId;
      if (userId != null) {
        // Initialize with default values
        totalWordsLearned.value = 0;
        totalQuizzesTaken.value = 0;
        totalGamesCompleted.value = 0;
        favoriteWordsCount.value = 0;
        currentStreak.value = 0;
        
        try {
          // Load favorites count
          var favorites = await FirebaseService.getUserFavorites(userId);
          favoriteWordsCount.value = favorites.length;
        } catch (e) {
          print('Error loading favorites: $e');
        }
        
        try {
          // Load quiz sessions to count quizzes taken
          // var quizSessions = await FirebaseService.getQuizSessions(userId);
          // totalQuizzesTaken.value = quizSessions.length;
          // currentStreak.value = calculateCurrentStreak(quizSessions);
        } catch (e) {
          print('Error loading quiz sessions: $e');
        }
        
        // Set some default statistics for now
        totalWordsLearned.value = favoriteWordsCount.value + totalQuizzesTaken.value * 5;
        totalGamesCompleted.value = totalQuizzesTaken.value;
      }
    } catch (e) {
      print('Error loading user statistics: $e');
    }
  }

  int calculateCurrentStreak(List quizSessions) {
    if (quizSessions.isEmpty) return 0;
    
    // Sort sessions by date (most recent first)
    quizSessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    int streak = 0;
    DateTime now = DateTime.now();
    DateTime currentDate = DateTime(now.year, now.month, now.day);
    
    for (var session in quizSessions) {
      DateTime sessionDate = DateTime(
        session.createdAt.year,
        session.createdAt.month,
        session.createdAt.day,
      );
      
      if (sessionDate == currentDate || sessionDate == currentDate.subtract(Duration(days: streak))) {
        streak++;
        currentDate = currentDate.subtract(Duration(days: 1));
      } else {
        break;
      }
    }
    
    return streak;
  }

  Future<void> loadSettings() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      isNotificationEnabled.value = prefs.getBool('notifications_enabled') ?? true;
      selectedLanguage.value = prefs.getString('app_language') ?? 'en';
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  Future<void> toggleNotification(bool value) async {
    try {
      isNotificationEnabled.value = value;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notifications_enabled', value);
    } catch (e) {
      print('Error saving notification setting: $e');
    }
  }

  List<String> languages = ["en", "zh", "ja"];

  void showLanguageSelectionDialog() {
    Get.defaultDialog(
      title: "selectlanguage".tr,
      titleStyle: TextStyle(fontWeight: FontWeight.bold),
      backgroundColor: whiteColor,
      titlePadding: EdgeInsets.all(16),
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      radius: 8,
      content: Column(
        children: [
          SizedBox(
            height: 150, 
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: languages.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Obx(() => ListTile(
                      minTileHeight: 8,
                      selected: selectedLanguage.value == languages[index],
                      title: Text(languages[index].tr),
                      trailing: selectedLanguage.value == languages[index] 
                          ? Icon(Icons.check, color: primaryColor)
                          : null,
                      onTap: () {
                        selectedLanguage.value = languages[index];
                      },
                    )),
                    Divider(
                      indent: 10,
                      endIndent: 10,
                      color: greyColor.withValues(alpha:0.5),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await saveLanguageSetting();
                // Get.back();
                Navigator.pop(Get.context!);
              },
              child: Text(
                "setlanguage".tr,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "cancel".tr,
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveLanguageSetting() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_language', selectedLanguage.value);
      
      // Update app locale
      Locale newLocale = Locale(selectedLanguage.value);
      Get.updateLocale(newLocale);
      
      SnackbarService.showSuccess(title: "Success", message: "Language updated successfully");
    } catch (e) {
      print('Error saving language setting: $e');
    }
  }

  Future<void> refreshProfile() async {
    await loadUserProfile();
    await loadUserStatistics();
  }

  void navigateToEditProfile() {
    Get.toNamed('/editprofile');
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text('logout'.tr),
        content: Text('areyousurelogout'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('no'.tr),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await FirebaseService.signout();
              await Get.find<HomeController>().removeFcm();
              Get.offAllNamed('/login');
            },
            child: Text('yes'.tr, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
