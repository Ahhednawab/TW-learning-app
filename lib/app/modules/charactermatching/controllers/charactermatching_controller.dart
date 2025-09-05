import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/models/word_model.dart';
import 'package:mandarinapp/app/models/user_progress_model.dart';
import 'package:mandarinapp/app/routes/app_pages.dart';
import 'package:mandarinapp/app/services/firebase_service.dart';

class CharacterMatchingPair {
  final String wordId;
  final String imageUrl;
  final String traditional;
  final String simplified;
  final String english;
  final WordModel word;
  final int originalIndex; // Track original position for image revealing

  CharacterMatchingPair({
    required this.wordId,
    required this.imageUrl,
    required this.traditional,
    required this.simplified,
    required this.english,
    required this.word,
    required this.originalIndex,
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

  var selectedChinese = (-1).obs;  // Selected Chinese word index
  var selectedEnglish = (-1).obs;  // Selected English word index

  // Tracks which pairs are matched/revealed
  var revealed = <bool>[].obs;
  var matchedPairs = <int>[].obs; // Stores indices of matched pairs
  
  // For showing wrong answer feedback
  var wrongAnswerFeedback = false.obs;
  var wrongChineseIndex = (-1).obs;
  var wrongEnglishIndex = (-1).obs;

  final AudioPlayer _audioPlayer = AudioPlayer();

  // Game data
  final RxList<List<CharacterMatchingPair>> gameRounds = <List<CharacterMatchingPair>>[].obs;
  final RxList<WordModel> allWords = <WordModel>[].obs;
  final RxList<String> chineseOptions = <String>[].obs; // Chinese characters in order
  final RxList<String> englishOptions = <String>[].obs; // English translations shuffled

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
          simplified: word.simplified,
          english: word.english,
          word: word,
          originalIndex: i, // Track original position for image revealing
        ));
      }
      
      rounds.add(pairs);
    }
    
    gameRounds.value = rounds;
    revealed.value = List.filled(4, false);
    
    // Generate options for the first round
    if (rounds.isNotEmpty) {
      generateRoundOptions();
    }
  }

  // Generate Chinese and English options for current round
  void generateRoundOptions() {
    if (gameRounds.isNotEmpty && currentIndex.value < gameRounds.length) {
      List<CharacterMatchingPair> currentRound = gameRounds[currentIndex.value];
      
      // Chinese characters remain in order
      chineseOptions.value = currentRound.map((pair) => pair.simplified).toList();
      
      // English translations are shuffled
      List<String> englishList = currentRound.map((pair) => pair.english).toList();
      englishList.shuffle();
      englishOptions.value = englishList;
      
      print('Chinese options: ${chineseOptions.value}');
      print('English options: ${englishOptions.value}');
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

  void selectChinese(int index) {
    if (matchedPairs.contains(index)) return; // Can't select already matched items
    selectedChinese.value = index;
    print('Selected Chinese: $index - ${chineseOptions[index]}');
    checkMatch();
  }

  void selectEnglish(int index) {
    if (isEnglishMatched(index)) return; // Can't select already matched items
    selectedEnglish.value = index;
    print('Selected English: $index - ${englishOptions[index]}');
    checkMatch();
  }

  // Check if this English option is already matched
  bool isEnglishMatched(int englishIndex) {
    String englishWord = englishOptions[englishIndex];
    List<CharacterMatchingPair> currentRound = gameRounds[currentIndex.value];
    
    for (int i = 0; i < currentRound.length; i++) {
      if (matchedPairs.contains(i) && currentRound[i].english == englishWord) {
        return true;
      }
    }
    return false;
  }

  void checkMatch() async {
  if (selectedChinese.value == -1 || selectedEnglish.value == -1 || gameRounds.isEmpty) {
    return;
  }
  
  List<CharacterMatchingPair> currentRound = gameRounds[currentIndex.value];
  
  // Get the selected Chinese and English words
  String selectedChineseWord = chineseOptions[selectedChinese.value];
  String selectedEnglishWord = englishOptions[selectedEnglish.value];
  
  print('Checking match: Chinese="${selectedChineseWord}" vs English="${selectedEnglishWord}"');
  
  // Find the matching pair in current round
  CharacterMatchingPair? matchingPair;
  for (var pair in currentRound) {
    if (pair.simplified == selectedChineseWord && pair.english == selectedEnglishWord) {
      matchingPair = pair;
      break;
    }
  }
  
  if (matchingPair != null) {
    // Correct match!
    int pairIndex = selectedChinese.value; // Chinese index corresponds to image position
    
    revealed[pairIndex] = true;
    revealed.refresh(); // ADD THIS LINE - Force reactive update
    matchedPairs.add(pairIndex);
    matchesFound.value++;
    score.value++;
    
    print('Correct match! Revealed image at index $pairIndex');
    
    // Clear selections
    selectedChinese.value = -1;
    selectedEnglish.value = -1;
    
    playSound('audio/correct.mp3');
    
    // Update word progress
    await updateWordProgress(matchingPair.word, true);
    
    // Check if all pairs in this round are matched
    if (matchesFound.value == currentRound.length) {
      await Future.delayed(Duration(milliseconds: 1500));
      await nextQuestion();
    }
  } else {
    // Wrong match - show red feedback
    wrongAnswerFeedback.value = true;
    wrongChineseIndex.value = selectedChinese.value;
    wrongEnglishIndex.value = selectedEnglish.value;
    
    print('Wrong match!');
    
    playSound('audio/failure.mp3');
    
    // Update word progress for incorrect answer (use first word as reference)
    if (currentRound.isNotEmpty) {
      await updateWordProgress(currentRound[selectedChinese.value].word, false);
    }
    
    // Reset after showing red feedback
    Future.delayed(Duration(milliseconds: 1000), () {
      wrongAnswerFeedback.value = false;
      wrongChineseIndex.value = -1;
      wrongEnglishIndex.value = -1;
      selectedChinese.value = -1;
      selectedEnglish.value = -1;
    });
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
      generateRoundOptions(); // Generate new options for the new round
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
      
      // Navigate to success screen
      Get.offNamed(Routes.FILLSUCCESS, arguments: {
        'score': score.value,
        'correctAnswers': score.value,
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
      matchedPairs.clear();
      matchesFound.value = 0;
      selectedChinese.value = -1;
      selectedEnglish.value = -1;
      wrongAnswerFeedback.value = false;
      wrongChineseIndex.value = -1;
      wrongEnglishIndex.value = -1;
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
