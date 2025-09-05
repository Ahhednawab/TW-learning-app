import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/word_model.dart';
import '../../../models/user_progress_model.dart';
import '../../../services/firebase_service.dart';

class SwipecardController extends GetxController with GetTickerProviderStateMixin {
  String categoryId = '';
  String categoryName = '';
  String levelId = '';
  
  final RxList<WordModel> words = <WordModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isCompletingActivity = false.obs;
  final RxBool isLiked = false.obs;
  final RxInt currentIndex = 0.obs;
  final RxDouble progress = 0.0.obs;
  final RxBool isLearning = false.obs;
  final RxInt knownCount = 0.obs;
  final RxInt learningCount = 0.obs;

  late AnimationController swipeController;
  late Animation<Offset> swipeAnimation;
  late AnimationController overlayController;
  late Animation<double> overlayAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    loadArguments();
    initializeAnimations();
    loadWords();
  }

  void loadArguments() {
    try {
      final args = Get.arguments as Map<String, dynamic>?;
      if (args != null) {
        categoryId = args['categoryId'] ?? '';
        categoryName = args['categoryName'] ?? '';
        levelId = args['levelId'] ?? '';
      }
    } catch (e) {
      print('Error loading arguments: $e');
    }
  }

  void initializeAnimations() {
    swipeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    swipeAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(2, 0))
        .animate(CurvedAnimation(parent: swipeController, curve: Curves.easeInOut));

    overlayController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    overlayAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: overlayController, curve: Curves.easeInOut));
  }

  Future<void> loadWords() async {
    try {
      isLoading.value = true;
      
      if (categoryId.isNotEmpty) {
        List<WordModel> categoryWords = await FirebaseService.getRandomWordsByCategory(categoryId, 10);
        words.value = categoryWords;
        
        if (words.isNotEmpty) {
          updateProgress();
          await checkCurrentWordFavoriteStatus();
        }
      }
    } catch (e) {
      print('Error loading words: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkCurrentWordFavoriteStatus() async {
    if (words.isNotEmpty && currentIndex.value < words.length) {
      String? userId = FirebaseService.currentUserId;
      if (userId != null) {
        String currentWordId = words[currentIndex.value].wordId;
        bool isFavorite = await FirebaseService.isWordFavorite(userId, currentWordId);
        isLiked.value = isFavorite;
      }
    }
  }

  Future<void> toggleLike() async {
    if (words.isEmpty || currentIndex.value >= words.length) return;
    
    String? userId = FirebaseService.currentUserId;
    if (userId != null) {
      WordModel currentWord = words[currentIndex.value];
      
      if (isLiked.value) {
        // Remove from favorites
        bool success = await FirebaseService.removeFromFavorites(userId, currentWord.wordId);
        if (success) {
          isLiked.value = false;
        }
      } else {
        // Add to favorites
        bool success = await FirebaseService.addToFavorites(userId, currentWord.wordId, categoryId, levelId);
        if (success) {
          isLiked.value = true;
        }
      }
    }
  }

  Future<void> playWordAudio() async {
    if (words.isNotEmpty && currentIndex.value < words.length) {
      WordModel currentWord = words[currentIndex.value];
      if (currentWord.audioUrl.isNotEmpty) {
        try {
          print('Playing audio: ${currentWord.audioUrl}');
          await _audioPlayer.setVolume(1.0);
          await _audioPlayer.stop();
          await _audioPlayer.play(UrlSource(currentWord.audioUrl));
        } catch (e) {
          print('Error playing audio: $e');
          // Fallback to asset audio if available
          playSound('audio/correct.mp3');
        }
      } else {
        // Fallback audio
        playSound('audio/correct.mp3');
      }
    }
  }

  void playSound(String filePath) async {
    try {
      await _audioPlayer.setVolume(0.4);
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(filePath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  Future<void> markKnown() async {
    if (words.isEmpty || currentIndex.value >= words.length) return;
    
    if (isLearning.value) {
      await overlayController.reverse();
      isLearning.value = false;
    }
    
    // Update word progress
    await updateWordProgress('known');
    knownCount.value++;
    
    playSound('audio/correct.mp3');
    await swipeController.forward();
    nextCard();
    swipeController.reset();
  }

  Future<void> markLearn() async {
    if (words.isEmpty || currentIndex.value >= words.length) return;
    
    // Update word progress
    await updateWordProgress('learning');
    learningCount.value++;
    
    isLearning.value = true;
    overlayController.forward();
  }

  Future<void> updateWordProgress(String status) async {
    if (words.isEmpty || currentIndex.value >= words.length) return;
    
    String? userId = FirebaseService.currentUserId;
    if (userId != null) {
      WordModel currentWord = words[currentIndex.value];
      
      WordProgress wordProgress = WordProgress(
        knownStatus: status,
        lastReviewed: DateTime.now(),
        reviewCount: 1,
        correctAnswers: status == 'known' ? 1 : 0,
        totalAnswers: 1,
        isFavorite: isLiked.value,
      );
      
      await FirebaseService.updateWordProgress(userId, categoryId, currentWord.wordId, wordProgress);
    }
  }

  void nextCard() {
    if (currentIndex.value < words.length - 1) {
      currentIndex.value++;
      updateProgress();
      checkCurrentWordFavoriteStatus();
    } else {
      // Complete the swipe cards activity
      completeActivity();
    }
  }

  Future<void> completeActivity() async {
    try {
      isCompletingActivity.value = true;
      
      String? userId = FirebaseService.currentUserId;
      if (userId != null) {
        // Calculate score based on known words
        int score = (knownCount.value / words.length * 100).round();
        
        // Update swipe cards completion with automatic unlocking
        await FirebaseService.updateActivityCompletion(
          userId,
          categoryId,
          'swipeCards', // activity type
          score,
          5, // timeSpent - approximate time spent
        );
        
        // Navigate to success screen
        Get.offNamed('/success', arguments: {
          'score': 100,
          'correctAnswers': knownCount.value,
          'totalQuestions': words.length,
          'categoryName': categoryName,
        });
      }
    } catch (e) {
      print('Error completing activity: $e');
    } finally {
      isCompletingActivity.value = false;
    }
  }

  void updateProgress() {
    if (words.isNotEmpty) {
      progress.value = (currentIndex.value + 1) / words.length;
    }
  }

  WordModel? get currentWord {
    if (words.isNotEmpty && currentIndex.value < words.length) {
      return words[currentIndex.value];
    }
    return null;
  }

  @override
  void onClose() {
    swipeController.dispose();
    overlayController.dispose();
    _audioPlayer.dispose();
    super.onClose();
  }
}
