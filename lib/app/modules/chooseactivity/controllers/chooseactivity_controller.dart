import 'package:get/get.dart';
import '../../../models/category_model.dart';
import '../../../models/user_progress_model.dart';
import '../../../services/firebase_service.dart';

class ChooseactivityController extends GetxController {
  String? activity;
  String categoryId = '';
  String categoryName = '';
  String levelId = '';
  
  final Rx<CategoryModel?> category = Rx<CategoryModel?>(null);
  final Rx<UserProgressModel?> userProgress = Rx<UserProgressModel?>(null);
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadArguments();
    loadData();
  }

  void refreshData(){
    loadData();
    getGamesProgress();
    getQuizProgress();
    getSwipeCardsProgress();
    getGamesProgressText();
    getQuizProgressText();
    getSwipeCardsProgressText();
  }

  void loadArguments() {
    try {
      final args = Get.arguments as Map<String, dynamic>?;
      if (args != null) {
        categoryId = args['categoryId'] ?? '';
        categoryName = args['categoryName'] ?? '';
        levelId = args['levelId'] ?? '';
        activity = args['activity'] ?? categoryName;
      }
    } catch (e) {
      print('Error loading arguments: $e');
      activity = 'chooseactivity';
    }
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      
      if (categoryId.isNotEmpty) {
        // Load category data
        CategoryModel? categoryData = await FirebaseService.getCategory(categoryId);
        category.value = categoryData;
        
        // Load user progress
        String? userId = FirebaseService.currentUserId;
        if (userId != null) {
          UserProgressModel? progress = await FirebaseService.getUserProgress(userId);
          userProgress.value = progress;
        }
      }
    } catch (e) {
      print('Error loading choose activity data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get activity progress
  ActivityProgress? getSwipeCardsProgress() {
    if (userProgress.value == null || categoryId.isEmpty) return null;
    return userProgress.value!.categories[categoryId]?.activities.swipeCards;
  }

  ActivityProgress? getQuizProgress() {
    if (userProgress.value == null || categoryId.isEmpty) return null;
    return userProgress.value!.categories[categoryId]?.activities.quiz;
  }

  GameProgress? getGamesProgress() {
    if (userProgress.value == null || categoryId.isEmpty) return null;
    return userProgress.value!.categories[categoryId]?.activities.games;
  }

  // Navigation methods
  void navigateToSwipeCards() {
    Get.toNamed('/swipecard', arguments: {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'levelId': levelId,
    });
  }

  void navigateToQuiz() {
    Get.toNamed('/quiz', arguments: {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'levelId': levelId,
    });
  }

  void navigateToGames() {
    Get.toNamed('/gamesselection', arguments: {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'levelId': levelId,
    });
  }

  // Progress text helpers
  String getSwipeCardsProgressText() {
    ActivityProgress? progress = getSwipeCardsProgress();
    if (progress == null) return '0/10';
    return progress.isCompleted ? '10/10' : '${(progress.score * 10 / 100).round()}/10';
  }

  String getQuizProgressText() {
    ActivityProgress? progress = getQuizProgress();
    if (progress == null) return '0/10';
    return progress.isCompleted ? '10/10' : '${(progress.score * 10 / 100).round()}/10';
  }

  String getGamesProgressText() {
    GameProgress? games = getGamesProgress();
    if (games == null) return '0/3';
    
    int completed = 0;
    if (games.fillInBlanks.isCompleted) completed++;
    if (games.characterMatching.isCompleted) completed++;
    if (games.listening.isCompleted) completed++;
    
    return '$completed/3';
  }
}
