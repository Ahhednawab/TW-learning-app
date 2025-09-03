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
  double calculateCategoryProgress(String categoryId) {
    if (userProgress.value == null) return 0.0;
    
    final categoryProgress = userProgress.value!.categories[categoryId];
    if (categoryProgress == null) return 0.0;
    
    // Calculate progress based on activities completion
    final activities = categoryProgress.activities;
    
    int completedActivities = 0;
    int totalActivities = 0;
    
    // Check swipeCards
    totalActivities++;
    if (activities.swipeCards.isCompleted) completedActivities++;
    
    // Check quiz
    totalActivities++;
    if (activities.quiz.isCompleted) completedActivities++;
    
    // Check games
    final games = activities.games;
    totalActivities++;
    if (games.fillInBlanks.isCompleted) completedActivities++;
    
    totalActivities++;
    if (games.characterMatching.isCompleted) completedActivities++;
    
    totalActivities++;
    if (games.listening.isCompleted) completedActivities++;
    
    if (totalActivities == 0) return 0.0;
    return (completedActivities / totalActivities) * 100;
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
      case 'animals':
        return Icons.pets;
      case 'appearance':
        return Icons.face;
      case 'culture':
        return Icons.museum;
      case 'buildings':
        return Icons.apartment;
      case 'nature':
        return Icons.nature;
      case 'sports':
        return Icons.sports;
      case 'food':
        return Icons.fastfood;
      case 'clothes':
        return Icons.checkroom;
      case 'travel':
        return Icons.travel_explore;
      case 'technology':
        return Icons.computer;
      case 'health':
        return Icons.health_and_safety;
      case 'education':
        return Icons.school;
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
