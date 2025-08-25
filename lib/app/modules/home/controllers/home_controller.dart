import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/user_model.dart';
import '../../../models/word_model.dart';
import '../../../models/daily_word_model.dart';
import '../../../models/user_progress_model.dart';
import '../../../models/quiz_session_model.dart';
import '../../../services/firebase_service.dart';
import '../../bottomnav/controllers/bottomnav_controller.dart';

class HomeController extends GetxController {
  final count = 0.obs;
  RxString? selectedLanguage = 'en'.obs;
  
  // User data observables
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final Rx<UserProgressModel?> userProgress = Rx<UserProgressModel?>(null);
  final Rx<WordModel?> wordOfTheDay = Rx<WordModel?>(null);
  final Rx<WordModel?> lastWordReviewed = Rx<WordModel?>(null);
  final RxInt timeSpentToday = 0.obs;
  final RxInt currentStreak = 0.obs;
  final RxString currentLevel = ''.obs;
  final RxInt wordsLearned = 0.obs;
  final RxInt totalWords = 0.obs;
  final RxBool isLoading = true.obs;

  List<String> languages = ['en', 'zh', 'ja'];

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      String? userId = FirebaseService.currentUserId;
      
      if (userId != null) {
        // Load user data
        UserModel? user = await FirebaseService.getUserData(userId);
        if (user != null) {
          currentUser.value = user;
          currentStreak.value = user.stats.currentStreak;
          
          // Get today's stats
          String today = DateTime.now().toIso8601String().split('T')[0];
          if (user.dailyStats.containsKey(today)) {
            timeSpentToday.value = user.dailyStats[today]!.timeSpent;
            
            // Get last word reviewed
            String lastWordId = user.dailyStats[today]!.lastWordReviewed;
            if (lastWordId.isNotEmpty) {
              WordModel? word = await FirebaseService.getWord(lastWordId);
              lastWordReviewed.value = word;
            }
          }
        }

        // Load user progress
        UserProgressModel? progress = await FirebaseService.getUserProgress(userId);
        if (progress != null) {
          userProgress.value = progress;
          currentLevel.value = progress.currentLevel;
          
          // Calculate words learned and total words
          int learned = 0;
          int total = 0;
          for (CategoryProgress categoryProgress in progress.categories.values) {
            for (WordProgress wordProgress in categoryProgress.wordsProgress.values) {
              total++;
              if (wordProgress.knownStatus == 'known') {
                learned++;
              }
            }
          }
          wordsLearned.value = learned;
          totalWords.value = total;
        }

        // Load word of the day
        DailyWordModel? dailyWord = await FirebaseService.getTodaysDailyWord();
        if (dailyWord != null) {
          WordModel? word = await FirebaseService.getWord(dailyWord.wordId);
          wordOfTheDay.value = word;
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await loadUserData();
  }

  String get userName {
    return currentUser.value?.profile.displayName ?? 'User';
  }

  String get userEmail {
    return currentUser.value?.profile.email ?? '';
  }

  String get wordOfTheDayText {
    return wordOfTheDay.value?.pinyin ?? 'nǐ hǎo';
  }

  String get lastWordReviewedText {
    return lastWordReviewed.value?.pinyin ?? 'xiè xiè';
  }

  String get timeSpentTodayText {
    return '${timeSpentToday.value} mins';
  }

  String get currentLevelText {
    switch (currentLevel.value.toLowerCase()) {
      case 'beginner':
        return 'beginner'.tr;
      case 'intermediate':
        return 'intermediate'.tr;
      case 'advanced':
        return 'advanced'.tr;
      default:
        return 'beginner'.tr;
    }
  }

  double get progressPercentage {
    if (totalWords.value == 0) return 0.0;
    return wordsLearned.value / totalWords.value;
  }

  void navigateToVocabulary() {
    Get.find<BottomnavController>().changeTabIndex(1);
  }

  void navigateToFavorites() {
    Get.find<BottomnavController>().changeTabIndex(2);
  }

  void navigateToProfile() {
    Get.find<BottomnavController>().changeTabIndex(3);
  }

  Future<void> continuePreviousQuiz() async {
    try {
      String? userId = FirebaseService.currentUserId;
      if (userId != null) {
        // Check for incomplete quiz session
        QuizSessionModel? incompleteSession = await FirebaseService.getLastIncompleteQuizSession(userId);
        
        if (incompleteSession != null) {
          // Navigate to quiz with existing session
          Get.toNamed('/quiz', arguments: {
            'sessionId': incompleteSession.sessionId,
            'categoryId': incompleteSession.categoryId,
          });
        } else {
          // Navigate to vocabulary to choose a category for new quiz
          navigateToVocabulary();
        }
      }
    } catch (e) {
      print('Error continuing quiz: $e');
      navigateToVocabulary();
    }
  }
}
