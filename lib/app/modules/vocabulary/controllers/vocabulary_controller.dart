import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/services/Snackbarservice.dart';
import '../../../models/level_model.dart';
import '../../../models/category_model.dart';
import '../../../models/user_progress_model.dart';
import '../../../services/firebase_service.dart';

class VocabularyController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  final ScrollController categoryScrollController = ScrollController();
  var isSearching = false.obs;

  // Firebase data observables
  final RxList<LevelModel> levels = <LevelModel>[].obs;
  final RxMap<String, List<CategoryModel>> categoriesByLevel = <String, List<CategoryModel>>{}.obs;
  final Rx<UserProgressModel?> userProgress = Rx<UserProgressModel?>(null);
  final RxBool isLoading = true.obs;
  final RxString selectedLevelId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      
      // Load levels
      List<LevelModel> loadedLevels = await FirebaseService.getAllLevels();
      levels.value = loadedLevels;
      
      if (loadedLevels.isNotEmpty) {
        // Load categories for each level
        for (LevelModel level in loadedLevels) {
          List<CategoryModel> categories = await FirebaseService.getCategoriesByLevel(level.levelId);
          categoriesByLevel[level.levelId] = categories;
        }
        
        // Load user progress
        String? userId = FirebaseService.currentUserId;
        if (userId != null) {
          UserProgressModel? progress = await FirebaseService.getUserProgress(userId);
          userProgress.value = progress;
          
          // Set initial selected level
          if (progress != null) {
            selectedLevelId.value = progress.currentLevel;
          } else if (loadedLevels.isNotEmpty) {
            selectedLevelId.value = loadedLevels.first.levelId;
          }
        }
        
        // Initialize tab controller
        tabController = TabController(length: loadedLevels.length, vsync: this);
        tabController.addListener(scrollToSelectedTab);
        
        // Set initial tab index based on current level
        int initialIndex = loadedLevels.indexWhere((level) => level.levelId == selectedLevelId.value);
        if (initialIndex != -1) {
          tabController.index = initialIndex;
        }
      }
    } catch (e) {
      print('Error loading vocabulary data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
  }

  void scrollToSelectedTab() {
    if (!categoryScrollController.hasClients) return;

    const double tabWidth = 100.0;
    final double screenWidth = Get.width;
    final double tabCenter = tabController.index * tabWidth + tabWidth / 1.5;
    double offset = tabCenter - (screenWidth / 2);
    final maxScroll = categoryScrollController.position.maxScrollExtent;
    offset = offset.clamp(0, maxScroll);

    categoryScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onTabChanged(int index) {
    if (index < levels.length) {
      selectedLevelId.value = levels[index].levelId;
    }
  }

  List<CategoryModel> getCategoriesForCurrentLevel() {
    return categoriesByLevel[selectedLevelId.value] ?? [];
  }

  bool isCategoryUnlocked(String categoryId) {
    if (userProgress.value == null) return false;
    return userProgress.value!.categories[categoryId]?.isUnlocked ?? false;
  }

  double getCategoryProgress(String categoryId) {
    return calculateCategoryProgress(categoryId);
  }

  // Local calculation of category progress based on userProgress data
  // Progress is calculated as: (total activity units / 3) * 100
  // The 3 main activities are: swipeCards, quiz, and games
  // - swipeCards: counts as 0 or 1 (binary)
  // - quiz: counts as 0 or 1 (binary)
  // - games: counts as 0 to 1 proportionally (0, 0.33, 0.67, or 1 based on how many of 3 games are completed)
  double calculateCategoryProgress(String categoryId) {
    if (userProgress.value == null) return 0.0;
    
    final categoryProgress = userProgress.value!.categories[categoryId];
    if (categoryProgress == null) return 0.0;
    
    // Calculate progress based on activities completion
    final activities = categoryProgress.activities;
    
    double activityProgress = 0.0;
    const int totalMainActivities = 3; // swipeCards, quiz, games
    
    // Activity 1: swipeCards (0 or 1)
    if (activities.swipeCards.isCompleted) activityProgress += 1.0;
    
    // Activity 2: quiz (0 or 1)
    if (activities.quiz.isCompleted) activityProgress += 1.0;
    
    // Activity 3: games (0, 0.33, 0.67, or 1)
    // Count how many of the 3 games are completed
    final games = activities.games;
    int completedGames = 0;
    if (games.fillInBlanks.isCompleted) completedGames++;
    if (games.characterMatching.isCompleted) completedGames++;
    if (games.listening.isCompleted) completedGames++;
    activityProgress += (completedGames / 3);
    
    return (activityProgress / totalMainActivities) * 100;
  }

  bool isLevelUnlocked(String levelId) {
    if (userProgress.value == null) return false;
    return userProgress.value!.unlockedLevels.contains(levelId);
  }

  void navigateToChooseActivity(CategoryModel category) {
    if (!isCategoryUnlocked(category.categoryId)) {
      SnackbarService.showError(title: 'locked'.tr, message: 'lockedinfo'.tr);
      return;
    }

    Get.toNamed('/chooseactivity', arguments: {
      'categoryId': category.categoryId,
      'categoryName': category.name,
      'levelId': category.levelId,
    });
  }

 IconData getCategoryIcon(String categoryName) {
  switch (categoryName.toLowerCase()) {

    // LEVEL 1
    case 'colors':
      return Icons.palette;
    case 'numbers':
      return Icons.onetwothree;
    case 'family':
      return Icons.family_restroom;
    case 'body_parts':
      return Icons.accessibility_new;
    case 'clothes':
      return Icons.checkroom;
    case 'school':
      return Icons.school;

    // LEVEL 2
    case 'jobs':
      return Icons.work;
    case 'hobbies':
      return Icons.interests;
    case 'sports':
      return Icons.sports_soccer;
    case 'travel':
      return Icons.travel_explore;
    case 'weather':
      return Icons.wb_sunny;
    case 'time':
      return Icons.access_time;

    // LEVEL 3
    case 'days_and_months':
      return Icons.calendar_month;
    case 'opposites':
      return Icons.compare_arrows;
    case 'synonyms':
      return Icons.sync_alt;
    case 'antonyms':
      return Icons.swap_horiz;
    case 'transportation':
      return Icons.directions_bus;
    case 'home':
      return Icons.home;

    // LEVEL 4
    case 'kitchen':
      return Icons.kitchen;
    case 'bathroom':
      return Icons.bathtub;
    case 'living_room':
      return Icons.weekend;
    case 'fruits':
      return Icons.local_grocery_store;
    case 'vegetables':
      return Icons.eco;
    case 'drinks':
      return Icons.local_drink;

    // LEVEL 5
    case 'places':
      return Icons.place;
    case 'countries':
      return Icons.public;
    case 'cities':
      return Icons.location_city;
    case 'technology':
      return Icons.computer;
    case 'emotions':
      return Icons.emoji_emotions;
    case 'shapes':
      return Icons.category;

    // DEFAULT
    default:
      return Icons.category;
  }
}

  @override
  void onClose() {
    tabController.dispose();
    categoryScrollController.dispose();
    super.onClose();
  }
}
