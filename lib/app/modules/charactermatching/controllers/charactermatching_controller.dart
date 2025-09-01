import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/models/word_model.dart';
import 'package:mandarinapp/app/models/user_progress_model.dart';
import 'package:mandarinapp/app/services/firebase_service.dart';

class CharacterMatchingPair {
  final String wordId;
  final String imageUrl;
  final String traditional;
  final String english;
  final WordModel word;

  CharacterMatchingPair({
    required this.wordId,
    required this.imageUrl,
    required this.traditional,
    required this.english,
    required this.word,
  });
}

class CharactermatchingController extends GetxController with GetTickerProviderStateMixin {
  // Game session data
  String categoryId = '';
  String levelId = '';
  String categoryName = '';
  
  // Observable variables
  var currentIndex = 0.obs;
  var matchesFound = 0.obs;
  var progress = 0.0.obs;
  var score = 0.obs;
  var isLoading = true.obs;

  var selectedLeft = (-1).obs;
  var selectedRight = (-1).obs;

  // Tracks which pairs are matched
  var revealed = <bool>[].obs;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Game data
  final RxList<List<CharacterMatchingPair>> gameRounds = <List<CharacterMatchingPair>>[].obs;
  final RxList<WordModel> allWords = <WordModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    
    // Get arguments from navigation
    final args = Get.arguments;
    if (args != null) {
      categoryId = args['categoryId'] ?? '';
      levelId = args['levelId'] ?? '';
      categoryName = args['categoryName'] ?? 'Character Matching';
    }
    
    loadGameData();
  }
  
  Future<void> loadGameData() async {
    try {
      isLoading.value = true;
      
      // Load words for this category
      List<WordModel> words = await FirebaseService.getWordsByCategory(categoryId);
      words.shuffle(); // Randomize the order
      allWords.value = words.take(12).toList(); // Take first 12 words
      
      if (words.isNotEmpty) {
        // Generate character matching rounds from words
        await generateMatchingRounds(words);
        resetQuestion();
      }
    } catch (e) {
      print('Error loading character matching data: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> generateMatchingRounds(List<WordModel> words) async {
    List<List<CharacterMatchingPair>> rounds = [];
    
    // Create 3 rounds with 4 pairs each
    for (int round = 0; round < 3 && round * 4 < words.length; round++) {
      List<CharacterMatchingPair> pairs = [];
      
      for (int i = 0; i < 4 && (round * 4 + i) < words.length; i++) {
        WordModel word = words[round * 4 + i];
        pairs.add(CharacterMatchingPair(
          wordId: word.wordId,
          imageUrl: word.imageUrl,
          traditional: word.traditional,
          english: word.english,
          word: word,
        ));
      }
      
      rounds.add(pairs);
    }
    
    gameRounds.value = rounds;
    revealed.value = List.filled(4, false);
  }

  void playSound(String filePath) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(filePath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void selectLeft(int index) {
    selectedLeft.value = index;
    checkMatch();
  }

  void selectRight(int index) {
    selectedRight.value = index;
    checkMatch();
  }

  void checkMatch() async {
    if (selectedLeft.value != -1 && selectedRight.value != -1 && gameRounds.isNotEmpty) {
      List<CharacterMatchingPair> currentRound = gameRounds[currentIndex.value];
      
      // Check if the selected left image matches the selected right text
      if (selectedLeft.value == selectedRight.value && selectedLeft.value < currentRound.length) {
        // Correct match
        revealed[selectedLeft.value] = true;
        matchesFound.value++;
        selectedLeft.value = -1;
        selectedRight.value = -1;
        score.value++;
        playSound('audio/correct.mp3');
        
        // Update word progress
        // await updateWordProgress(currentRound[selectedLeft.value].word, true);
        
        if (matchesFound.value == currentRound.length) {
          await Future.delayed(Duration(milliseconds: 1000));
          await nextQuestion();
        }
      } else {
        // Wrong match
        playSound('audio/failure.mp3');
        
        // Update word progress for incorrect answer
        if (selectedLeft.value < currentRound.length) {
          await updateWordProgress(currentRound[selectedLeft.value].word, false);
        }
        
        Future.delayed(Duration(milliseconds: 800), () {
          selectedLeft.value = -1;
          selectedRight.value = -1;
        });
      }
    }
  }
  
  Future<void> updateWordProgress(WordModel word, bool isCorrect) async {
    String? userId = FirebaseService.currentUserId;
    if (userId != null) {
      WordProgress wordProgress = WordProgress(
        knownStatus: isCorrect ? 'known' : 'learning',
        lastReviewed: DateTime.now(),
        reviewCount: 1,
        correctAnswers: isCorrect ? 1 : 0,
        totalAnswers: 1,
        isFavorite: false,
      );
      
      await FirebaseService.updateWordProgress(userId, categoryId, word.wordId, wordProgress);
    }
  }

  Future<void> nextQuestion() async {
    if (currentIndex.value < gameRounds.length - 1) {
      currentIndex.value++;
      resetQuestion();
    } else {
      // Complete the game
      await completeGame();
    }
  }
  
  Future<void> completeGame() async {
    try {
      String? userId = FirebaseService.currentUserId;
      
      if (userId != null) {
        // Update character matching game completion with automatic unlocking
        await FirebaseService.updateActivityCompletion(
          userId,
          categoryId,
          'games', // activity type
          score.value,
          0, // timeSpent - could be tracked if needed
          gameType: 'characterMatching',
        );
      }
      
      // Show completion dialog
      // Navigate to success screen
        Get.offNamed('/success', arguments: {
          'score': matchesFound.value,
          'correctAnswers': matchesFound.value,
          'totalQuestions': gameRounds.length * 4,
          'categoryName': categoryName,
        });
      
    } catch (e) {
      print('Error completing game: $e');
      Get.back();
    }
  }

  void passQuestion() async {
    await nextQuestion();
  }

  void resetQuestion() {
    if (gameRounds.isNotEmpty && currentIndex.value < gameRounds.length) {
      revealed.value = List.filled(gameRounds[currentIndex.value].length, false);
      matchesFound.value = 0;
      selectedLeft.value = -1;
      selectedRight.value = -1;
      progress.value = (currentIndex.value + 1) / gameRounds.length;
    }
  }
  
  List<CharacterMatchingPair> get currentRound {
    if (gameRounds.isNotEmpty && currentIndex.value < gameRounds.length) {
      return gameRounds[currentIndex.value];
    }
    return [];
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
