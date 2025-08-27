import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mandarinapp/app/models/word_model.dart';
import 'package:mandarinapp/app/models/user_progress_model.dart';
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

  // Store color states for each option
  var answerColor = <int, Color>{}.obs;

  final AudioPlayer _audioPlayer = AudioPlayer();

  // Game data
  final RxList<ListeningQuestion> questions = <ListeningQuestion>[].obs;
  final RxList<WordModel> allWords = <WordModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    
    // Get arguments from navigation
    final args = Get.arguments;
    if (args != null) {
      categoryId = args['categoryId'] ?? '';
      levelId = args['levelId'] ?? '';
      categoryName = args['categoryName'] ?? 'Listening';
    }
    
    loadGameData();
  }

  // Load words from Firestore and generate questions
  Future<void> loadGameData() async {
    try {
      isLoading.value = true;
      
      // Load words for the category
      List<WordModel> words = await FirebaseService.getWordsByCategory(categoryId);
      
      if (words.isEmpty) {
        Get.snackbar('Error', 'No words found for this category');
        Get.back();
        return;
      }
      
      allWords.value = words;
      generateQuestions();
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to load game data: $e');
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
    List<String> options = [correctWord.simplified];
    
    // Add 3 random incorrect options
    List<WordModel> otherWords = allWords.where((w) => w.wordId != correctWord.wordId).toList();
    otherWords.shuffle();
    
    for (int i = 0; i < 3 && i < otherWords.length; i++) {
      options.add(otherWords[i].simplified);
    }
    
    // If we don't have enough words, add some fallback options
    while (options.length < 4) {
      options.add('Option ${options.length}');
    }
    
    options.shuffle();
    return options;
  }

  // Play audio for current question
  Future<void> playAudio() async {
    if (questions.isEmpty || currentIndex.value >= questions.length) return;
    
    try {
      isPlaying.value = true;
      ListeningQuestion question = questions[currentIndex.value];
      
      await _audioPlayer.stop();
      
      if (question.audioUrl.isNotEmpty) {
        await _audioPlayer.play(UrlSource(question.audioUrl));
      } else {
        // Fallback to asset audio if available
        await _audioPlayer.play(AssetSource('audio/dog.mp3'));
      }
      
    } catch (e) {
      print('Error playing audio: $e');
      // Play fallback sound
      await _audioPlayer.play(AssetSource('audio/dog.mp3'));
    } finally {
      isPlaying.value = false;
    }
  }

  // Play feedback sound
  Future<void> playSound(String filePath) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(filePath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  // Handle option selection
  Future<void> selectOption(int index) async {
    if (selectedOption.value != -1 || questions.isEmpty) return; // Prevent double tap
    
    selectedOption.value = index;
    ListeningQuestion question = questions[currentIndex.value];
    bool isCorrect = index == question.correctIndex;
    
    if (isCorrect) {
      answerColor[index] = const Color(0xFFD0F0C0); // green
      await playSound('audio/correct.mp3');
      score.value++;
    } else {
      answerColor[index] = const Color(0xFFF4C2C2); // red
      answerColor[question.correctIndex] = const Color(0xFFD0F0C0); // show correct
      await playSound('audio/failure.mp3');
    }
    
    // Update word progress
    await updateWordProgress(isCorrect);
    
    // Delay before moving to next question
    Future.delayed(const Duration(milliseconds: 1500), nextQuestion);
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
      String? userId = FirebaseService.currentUserId;
      
      if (userId != null) {
 
        ActivityProgress activityProgress = ActivityProgress(
          isCompleted: true,
          completedAt: DateTime.now(),
          score: score.value,
          timeSpent: 5, // Approximate time spent
        );
        
        await FirebaseService.updateActivityProgressInGames(userId, categoryId, 'listening', activityProgress);
      }
      
      // Show completion dialog
      Get.dialog(
        AlertDialog(
          title: const Text('Game Complete!'),
          content: Text('Score: ${score.value}/${questions.length}'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog
                Get.back(); // Return to games selection
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      
    } catch (e) {
      print('Error completing game: $e');
      Get.back();
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
