import 'package:get/get.dart';
import 'package:mandarinapp/app/models/category_model.dart';
import 'package:mandarinapp/app/models/user_progress_model.dart';
import 'package:mandarinapp/app/services/firebase_service.dart';
import 'package:mandarinapp/app/routes/app_pages.dart';

class GamesselectionController extends GetxController {
  // Navigation data
  String categoryId = '';
  String levelId = '';
  String categoryName = '';
  
  // Observable variables
  var isLoading = true.obs;
  final Rx<CategoryModel?> category = Rx<CategoryModel?>(null);
  final Rx<UserProgressModel?> userProgress = Rx<UserProgressModel?>(null);
  
  @override
  void onInit() {
    super.onInit();
    
    // Get arguments from navigation
    final args = Get.arguments;
    if (args != null) {
      categoryId = args['categoryId'] ?? '';
      levelId = args['levelId'] ?? '';
      categoryName = args['categoryName'] ?? 'Games';
    }
    
    loadGameData();
  }
  
  Future<void> loadGameData() async {
    try {
      isLoading.value = true;
      
      String? userId = FirebaseService.currentUserId;
      if (userId != null && categoryId.isNotEmpty) {
        // Load user progress for this category
        UserProgressModel? progress = await FirebaseService.getUserProgress(userId);
        userProgress.value = progress;
      }
    } catch (e) {
      print('Error loading game data: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Get progress for Fill Blanks game
  String getFillBlanksProgress() {
    // if (userProgress.value?.categories[categoryId]?.activities['fillBlanks']?.isCompleted == true) {
    //   return 'Completed';
    // }
    return '0/10'; // Default for fill blanks
  }
  
  // Get progress for Character Matching game
  String getCharacterMatchingProgress() {
    // if (userProgress.value?.categories[categoryId]?.activities['characterMatching']?.isCompleted == true) {
    //   return 'Completed';
    // }
    return '0/3'; // Default for character matching
  }
  
  // Get progress for Listening game
  String getListeningProgress() {
    // if (userProgress.value?.categories[categoryId]?.activities['listening']?.isCompleted == true) {
    //   return 'Completed';
    // }
    return '0/3'; // Default for listening
  }
  
  // Navigation methods
  void navigateToFillBlanks() {
    Get.toNamed(Routes.FILLBLANKS, arguments: {
      'categoryId': categoryId,
      'levelId': levelId,
      'categoryName': categoryName,
    });
  }
  
  void navigateToCharacterMatching() {
    Get.toNamed(Routes.CHARACTERMATCHING, arguments: {
      'categoryId': categoryId,
      'levelId': levelId,
      'categoryName': categoryName,
    });
  }
  
  void navigateToListening() {
    Get.toNamed(Routes.LISTENING, arguments: {
      'categoryId': categoryId,
      'levelId': levelId,
      'categoryName': categoryName,
    });
  }
}
