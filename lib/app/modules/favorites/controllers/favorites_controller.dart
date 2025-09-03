import 'package:get/get.dart';
import 'package:mandarinapp/app/models/word_model.dart';
import 'package:mandarinapp/app/models/favorite_model.dart';
import 'package:mandarinapp/app/services/Snackbarservice.dart' show SnackbarService;
import 'package:mandarinapp/app/services/firebase_service.dart';

class FavoritesController extends GetxController {
  // Observable variables
  var isLoading = true.obs;
  final RxList<WordModel> favoriteWords = <WordModel>[].obs;
  final RxList<FavoriteModel> favorites = <FavoriteModel>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }
  
  Future<void> loadFavorites() async {
    try {
      isLoading.value = true;
      
      String? userId = FirebaseService.currentUserId;
      if (userId != null) {
        // Load user's favorite words
        List<FavoriteModel> userFavorites = await FirebaseService.getUserFavorites(userId);
        favorites.value = userFavorites;
        
        // Load the actual word data for each favorite
        List<WordModel> words = [];
        for (FavoriteModel favorite in userFavorites) {
          try {
            // Get word details directly by wordId
            WordModel? word = await FirebaseService.getWord(favorite.wordId);
            if (word != null) {
              words.add(word);
            }
          } catch (e) {
            print('Error loading word ${favorite.wordId}: $e');
          }
        }
        favoriteWords.value = words;
      }
    } catch (e) {
      print('Error loading favorites: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> removeFromFavorites(String wordId) async {
    try {
      String? userId = FirebaseService.currentUserId;
      if (userId != null) {
        bool success = await FirebaseService.removeFromFavorites(userId, wordId);
        if (success) {
          // Remove from local lists
          favorites.removeWhere((fav) => fav.wordId == wordId);
          favoriteWords.removeWhere((word) => word.wordId == wordId);
          
          SnackbarService.showSuccess(
            title: 'Success',
            message: 'Removed from favorites',
          );
        }
      }
    } catch (e) {
      print('Error removing from favorites: $e');
      SnackbarService.showError(title: 'Error', message: 'Failed to remove from favorites');
    }
  }
  
  Future<void> refreshFavorites() async {
    await loadFavorites();
  }
  
  bool get hasFavorites => favoriteWords.isNotEmpty;
}
