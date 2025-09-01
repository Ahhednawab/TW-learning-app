import 'package:get/get.dart';
import 'package:mandarinapp/app/models/level_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/user_model.dart';
import '../../../models/word_model.dart';
import '../../../models/daily_word_model.dart';
import '../../../models/user_progress_model.dart';
import '../../../models/quiz_session_model.dart';
import '../../../services/firebase_service.dart';
import '../../../services/streak_service.dart';
import '../../../services/word_of_day_service.dart';
import '../../bottomnav/controllers/bottomnav_controller.dart';

class HomeController extends GetxController {
  final count = 0.obs;
  RxString? selectedLanguage = 'en'.obs;

    // Time tracking variables
  var timeSpentInMillis = 0.obs; // Time spent in milliseconds
  final int maxTimeInMillis = 60 * 60 * 1000; // 1 hour in milliseconds
  
  // User data observables
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final Rx<UserProgressModel?> userProgress = Rx<UserProgressModel?>(null);
  final Rx<WordModel?> wordOfTheDay = Rx<WordModel?>(null);
  final Rx<WordModel?> lastWordReviewed = Rx<WordModel?>(null);
  final RxInt currentStreak = 0.obs;
  final RxString currentLevel = ''.obs;
  final RxInt wordsLearned = 0.obs;
  final RxInt totalWords = 0.obs;
  final RxBool isLoading = true.obs;

  List<String> languages = ['en', 'zh', 'ja'];


  Future<String> getLevelName() async {
    LevelModel? level = await FirebaseService.getLevel(currentLevel.value);
    return level?.name ?? 'Level 1';
  }

  // Getters for UI
  String get userName => currentUser.value?.profile.displayName ?? 'User';
  String get currentLevelText => currentLevel.value.isNotEmpty ? 'Level ${getLevelName()}' : 'Level 1';
  String get wordOfTheDayText => wordOfTheDay.value?.pinyin ?? 'xiè xiè';
  String get lastWordReviewedText => lastWordReviewed.value?.english ?? 'nǐ hǎo';


  @override
  void onInit() {
    super.onInit();
    loadUserData();
    initializeStreakTracking();
    _initializeSessionTime();
  }

   Future<void> _initializeSessionTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int lastOpened = prefs.getInt('last_opened') ?? 0;
  int now = DateTime.now().millisecondsSinceEpoch;

  // If the session start time is missing or older than today, reset it
  if (lastOpened == 0 || DateTime.fromMillisecondsSinceEpoch(lastOpened).day != DateTime.now().day) {
    prefs.setInt('last_opened', now); // Save new session start time
    timeSpentInMillis.value = 0; // Reset time spent to 0 for the first time
  } else {
    // Calculate elapsed time
    int elapsed = now - lastOpened;
    timeSpentInMillis.value = elapsed; // Update time spent in milliseconds
  }
}


  Future<void> initializeStreakTracking() async {
    try {
    // Start learning session
    await StreakService.startSession();
    
    // Update streak for today
    await StreakService.updateStreak();
    
    // Load streak and time data
    currentStreak.value = await StreakService.getLearningStreak();
  
    
    // Load word of the day
    WordModel? todayWord = await WordOfDayService.getWordOfDay();
    wordOfTheDay.value = todayWord;
    
    // Load last word reviewed
    Map<String, dynamic>? lastReviewed = await WordOfDayService.getLastWordReviewed();
    if (lastReviewed != null) {
      lastWordReviewed.value = lastReviewed['word'] as WordModel?;
    }
    } catch (e) {
      print('Error initializing streak tracking: $e');
    }
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

  String get userEmail {
    return currentUser.value?.profile.email ?? '';
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
