import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mandarinapp/app/models/user_progress_model.dart';
import 'package:mandarinapp/app/models/word_model.dart';
import 'package:mandarinapp/app/routes/app_pages.dart';
import 'package:mandarinapp/app/services/Snackbarservice.dart';
import 'package:mandarinapp/app/services/firebase_service.dart';

class ListeningQuestion {
  final String wordId;
  final String imageUrl;
  final String audioUrl;
  final String traditional;
  final String pinyin;
  final String english;
  final List<String> options;
  final int correctIndex;
  final WordModel word;

  ListeningQuestion({
    required this.wordId,
    required this.imageUrl,
    required this.audioUrl,
    required this.traditional,
    required this.pinyin,
    required this.english,
    required this.options,
    required this.correctIndex,
    required this.word,
  });
}

class ListeningController extends GetxController with GetTickerProviderStateMixin {
  // Game session data
  String categoryId = '';
  String levelId = '';
  String categoryName = '';
  
  // Observable variables
  var currentIndex = 0.obs;
  var progress = 0.0.obs;
  var score = 0.obs;
  var selectedOption = (-1).obs;
  var isLoading = true.obs;
  var isPlaying = false.obs;
  var isCompletingActivity = false.obs;

  // Store color states for each option
  var answerColor = <int, Color>{}.obs;

  final AudioPlayer _audioPlayer = AudioPlayer();
  late final FlutterTts _flutterTts;

  // Game data
  final RxList<ListeningQuestion> questions = <ListeningQuestion>[].obs;
  final RxList<WordModel> allWords = <WordModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initTts();
    // Get arguments from navigation
    final args = Get.arguments;
    if (args != null) {
      categoryId = args['categoryId'] ?? '';
      levelId = args['levelId'] ?? '';
      categoryName = args['categoryName'] ?? 'Listening';
    }
    
    loadGameData();
  }

   void _initTts() {
    _flutterTts = FlutterTts();

    // Adjust these as needed for your UX
    _flutterTts.setLanguage('zh-TW');
    _flutterTts.setSpeechRate(0.4); // slower for learning
    _flutterTts.setPitch(1.0);
    _flutterTts.setVolume(1.0);
  }

  // Load words from Firestore and generate questions
  Future<void> loadGameData() async {
    try {
      isLoading.value = true;
      
      // Load words for the category
      List<WordModel> words = await FirebaseService.getWordsByCategory(categoryId);
      
      if (words.isEmpty) {
        SnackbarService.showError(title: 'Error', message: 'No words found for this category');
        Get.back();
        return;
      }
      
      allWords.value = words;
      generateQuestions();
      
    } catch (e) {
      SnackbarService.showError(title: 'Error', message: 'Failed to load game data: $e');
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  // Generate listening questions from words
  void generateQuestions() {
    questions.clear();
    
    // Take up to 10 words for the game
    List<WordModel> gameWords = allWords.take(10).toList();
    
    for (int i = 0; i < gameWords.length; i++) {
      WordModel word = gameWords[i];
      
      // Generate 4 options including the correct answer
      List<String> options = generateOptions(word, gameWords);
      int correctIndex = options.indexOf(word.english);
      
      questions.add(ListeningQuestion(
        wordId: word.wordId,
        imageUrl: word.imageUrl,
        audioUrl: word.audioUrl,
        traditional: word.traditional,
        pinyin: word.pinyin,
        english: word.english,
        options: options,
        correctIndex: correctIndex,
        word: word,
      ));
    }
    
    // Shuffle questions
    questions.shuffle();
    updateProgress();
  }

  // Generate 4 options for multiple choice
  List<String> generateOptions(WordModel correctWord, List<WordModel> allWords) {
    List<String> options = [correctWord.english];
    
    // Add 3 random incorrect options
    List<WordModel> otherWords = allWords.where((w) => w.wordId != correctWord.wordId).toList();
    otherWords.shuffle();
    
    for (int i = 0; i < 3 && i < otherWords.length; i++) {
      options.add(otherWords[i].english);
    }
    
    // If we don't have enough words, add some fallback options
    while (options.length < 4) {
      options.add('Option ${options.length}');
    }
    
    options.shuffle();
    return options;
  }

  // Play audio for current question
  // NEW: helper to speak text
  Future<void> _speakWord(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    try {
      await _flutterTts.stop();
      await _flutterTts.speak(trimmed);
    } catch (e) {
      print('Error playing word with TTS: $e');
    }
  }

  /// UPDATED: now uses TTS to play the current word.
  Future<void> playAudio() async {
    if (questions.isNotEmpty && currentIndex.value < questions.length) {
      ListeningQuestion currentWord = questions[currentIndex.value];

      try {
        // Stop any previous audio / TTS to avoid overlaps
        await _audioPlayer.stop();
        await _flutterTts.stop();
      } catch (_) {}

      // 1. Primary: speak the word text via TTS
      try {
        // Replace `currentWord.word` with your correct field if needed
        final String wordText = currentWord.traditional;
        if (wordText.isNotEmpty) {
          await _speakWord(wordText);
          return;
        }
      } catch (e) {
        print('Error accessing word text for TTS: $e');
      }

      // 2. Fallback: play remote audio if available
      if (currentWord.audioUrl.isNotEmpty) {
        try {
          print('Playing audio: ${currentWord.audioUrl}');
          await _audioPlayer.setVolume(1.0);
          await _audioPlayer.stop();
          await _audioPlayer.play(UrlSource(currentWord.audioUrl));
          return;
        } catch (e) {
          print('Error playing audio url, will fallback sound: $e');
        }
      }

      // 3. Last fallback: generic asset sound
      playSound('audio/correct.mp3');
    }
  }

  // Play feedback sound
  Future<void> playSound(String filePath) async {
    try {
      await _audioPlayer.setVolume(0.4);
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(filePath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  // Handle option selection
  Future<void> selectOption(int index) async {
    if (questions.isEmpty) return;
    
    ListeningQuestion question = questions[currentIndex.value];
    bool isCorrect = index == question.correctIndex;
    
    if (isCorrect) {
      selectedOption.value = index;
      answerColor[index] = const Color(0xFFD0F0C0); // green
      await playSound('audio/correct.mp3');
      score.value++;
      
      // Update word progress
      await updateWordProgress(isCorrect);
      
      // Delay before moving to next question
      Future.delayed(const Duration(milliseconds: 1500), nextQuestion);
    } else {
      // Wrong answer - highlight in red but don't proceed
      answerColor[index] = const Color(0xFFF4C2C2); // red
      await playSound('audio/failure.mp3');
      
      // Clear the red highlight after a short delay to allow retry
      Future.delayed(const Duration(milliseconds: 800), () {
        answerColor.remove(index);
      });
    }
  }

  // Update word progress in Firestore
  Future<void> updateWordProgress(bool isCorrect) async {
    if (questions.isEmpty || currentIndex.value >= questions.length) return;
    
    try {
      ListeningQuestion question = questions[currentIndex.value];
      String? userId = FirebaseService.currentUserId;
      
      if (userId != null) {
        WordProgress wordProgress = WordProgress(
          knownStatus: isCorrect ? 'learning' : 'unknown',
          lastReviewed: DateTime.now(),
          reviewCount: 1,
          correctAnswers: isCorrect ? 1 : 0,
          totalAnswers: 1,
          isFavorite: false,
        );
        
        await FirebaseService.updateWordProgress(
          userId,
          categoryId,
          question.wordId,
          wordProgress,
        );
      }
      
    } catch (e) {
      print('Error updating word progress: $e');
    }
  }

  // Move to next question
  void nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
      selectedOption.value = -1;
      answerColor.clear();
      updateProgress();
    } else {
      // Game completed
      completeGame();
    }
  }

  // Update progress
  void updateProgress() {
    if (questions.isNotEmpty) {
      progress.value = (currentIndex.value + 1) / questions.length;
    }
  }

  // Pass current question
  Future<void> passQuestion() async {
    if (questions.isEmpty || selectedOption.value != -1) return;
    
    // Mark as incorrect and update progress
    await updateWordProgress(false);
    
    // Show correct answer
    ListeningQuestion question = questions[currentIndex.value];
    answerColor[question.correctIndex] = const Color(0xFFD0F0C0);
    selectedOption.value = -2; // Special value for passed question
    
    Future.delayed(const Duration(milliseconds: 1500), nextQuestion);
  }

  // Complete the game
  Future<void> completeGame() async {
    try {
      isCompletingActivity.value = true;
      
      String? userId = FirebaseService.currentUserId;
      
      if (userId != null) {
        // Update listening game completion with automatic unlocking
        await FirebaseService.updateActivityCompletion(
          userId,
          categoryId,
          'games', // activity type
          score.value,
          0, // timeSpent - could be tracked if needed
          gameType: 'listening',
        );
      }
      
      // Show completion dialog
      // Navigate to success screen
        Get.offNamed(Routes.FILLSUCCESS, arguments: {
          'score': score.value,
          'correctAnswers': score.value,
          'totalQuestions': questions.length,
          'categoryName': categoryName,
        });
      
    } catch (e) {
      print('Error completing listening game: $e');
      Get.back();
    } finally {
      isCompletingActivity.value = false;
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
