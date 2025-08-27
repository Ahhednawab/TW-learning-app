import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/routes/app_pages.dart';
import 'package:mandarinapp/app/models/word_model.dart';
import 'package:mandarinapp/app/models/user_progress_model.dart';
import 'package:mandarinapp/app/services/firebase_service.dart';

class FillBlankQuestion {
  final String wordId;
  final String imageUrl;
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final WordModel correctWord;

  FillBlankQuestion({
    required this.wordId,
    required this.imageUrl,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    required this.correctWord,
  });
}

class FillblanksController extends GetxController with GetTickerProviderStateMixin {
  // Game session data
  String categoryId = '';
  String levelId = '';
  String categoryName = '';
  
  // Observable variables
  var currentIndex = 0.obs;
  var progress = 0.0.obs;
  var selectedOption = (-1).obs;
  var answerColor = <int, Color>{}.obs;
  var score = 0.obs;
  var isLoading = true.obs;
  
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController swipeController;
  late Animation<Offset> swipeAnimation;
  
  // Game data
  final RxList<FillBlankQuestion> questions = <FillBlankQuestion>[].obs;
  final RxList<WordModel> allWords = <WordModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    
    // Get arguments from navigation
    final args = Get.arguments;
    if (args != null) {
      categoryId = args['categoryId'] ?? '';
      levelId = args['levelId'] ?? '';
      categoryName = args['categoryName'] ?? 'Fill Blanks';
    }
    
    swipeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    swipeAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(-2, 0))
        .animate(CurvedAnimation(parent: swipeController, curve: Curves.easeInOut));
    
    loadGameData();
  }
  
  Future<void> loadGameData() async {
    try {
      isLoading.value = true;
      
      // Load words for this category
      List<WordModel> words = await FirebaseService.getRandomWordsByCategory(categoryId, 10);
      allWords.value = words;
      
      if (words.isNotEmpty) {
        // Generate fill blank questions from words
        await generateFillBlankQuestions(words);
        updateProgress();
      }
    } catch (e) {
      print('Error loading fill blanks data: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> generateFillBlankQuestions(List<WordModel> words) async {
    List<FillBlankQuestion> generatedQuestions = [];
    
    // Sample sentence templates for fill blanks
    List<String> sentenceTemplates = [
      "我喜歡 ______。\n(Wǒ xǐhuān ______.)",
      "我有一隻 ______。\n(Wǒ yǒu yī zhī ______.)",
      "他養了一隻 ______。\n(Tā yǎngle yī zhī ______.)",
      "天空有一隻 ______。\n(Tiānkōng yǒu yī zhī ______.)",
      "我看到一頭 ______。\n(Wǒ kàndào yī tóu ______.)",
      "這是一隻 ______。\n(Zhè shì yī zhī ______.)",
      "動物園有一隻 ______。\n(Dòngwùyuán yǒu yī zhī ______.)",
      "我想要一隻 ______。\n(Wǒ xiǎng yào yī zhī ______.)",
      "叢林裡有一隻 ______。\n(Cónglín lǐ yǒu yī zhī ______.)",
      "山上有一隻 ______。\n(Shān shàng yǒu yī zhī ______.)",
    ];
    
    for (int i = 0; i < words.length && i < 10; i++) {
      WordModel correctWord = words[i];
      
      // Get 3 random incorrect options from other words
      List<WordModel> otherWords = List.from(words);
      otherWords.removeAt(i);
      otherWords.shuffle();
      
      List<String> options = [];
      List<WordModel> optionWords = [correctWord];
      
      // Add 3 incorrect options
      for (int j = 0; j < 3 && j < otherWords.length; j++) {
        optionWords.add(otherWords[j]);
      }
      
      // Shuffle options
      optionWords.shuffle();
      
      // Find correct index after shuffle
      int correctIndex = optionWords.indexOf(correctWord);
      
      // Create option strings
      for (WordModel word in optionWords) {
        options.add('${word.traditional} (${word.pinyin})');
      }
      
      // Use a random sentence template or the word's example sentence
      String questionText = sentenceTemplates[i % sentenceTemplates.length];
      if (correctWord.exampleSentence.traditional.isNotEmpty) {
        // Replace the word with blank in the example sentence if available
        questionText = correctWord.exampleSentence.traditional.replaceAll(correctWord.traditional, '______') + 
                     '\n(' + correctWord.exampleSentence.pinyin.replaceAll(correctWord.pinyin, '______') + ')';
      }
      
      generatedQuestions.add(FillBlankQuestion(
        wordId: correctWord.wordId,
        imageUrl: correctWord.imageUrl,
        questionText: questionText,
        options: options,
        correctIndex: correctIndex,
        correctWord: correctWord,
      ));
    }
    
    questions.value = generatedQuestions;
  }

  void playSound(String filePath) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(filePath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void selectOption(int index) async {
    if (selectedOption.value != -1 || questions.isEmpty) return; // Prevent double tap
    selectedOption.value = index;

    bool isCorrect = index == questions[currentIndex.value].correctIndex;
    
    if (isCorrect) {
      answerColor[index] = Colors.lightGreen;
      playSound('audio/correct.mp3');
      score.value += 1;
      
      // Update word progress
      await updateWordProgress(true);
      
      await Future.delayed(const Duration(milliseconds: 500));
      await swipeController.forward();
      nextQuestion();
      swipeController.reset();
    } else {
      answerColor[index] = Colors.red.shade200;
      playSound('audio/failure.mp3');
      
      // Update word progress
      await updateWordProgress(false);
      
      await Future.delayed(const Duration(seconds: 1));
      answerColor.remove(index);
      selectedOption.value = -1; // Allow retry
    }
  }
  
  Future<void> updateWordProgress(bool isCorrect) async {
    if (questions.isEmpty || currentIndex.value >= questions.length) return;
    
    String? userId = FirebaseService.currentUserId;
    if (userId != null) {
      WordModel currentWord = questions[currentIndex.value].correctWord;
      
      WordProgress wordProgress = WordProgress(
        knownStatus: isCorrect ? 'known' : 'learning',
        lastReviewed: DateTime.now(),
        reviewCount: 1,
        correctAnswers: isCorrect ? 1 : 0,
        totalAnswers: 1,
        isFavorite: false,
      );
      
      await FirebaseService.updateWordProgress(userId, categoryId, currentWord.wordId, wordProgress);
    }
  }

  void passQuestion() async {
    await swipeController.forward();
    nextQuestion();
    swipeController.reset();
  }

  void nextQuestion() async {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
      selectedOption.value = -1;
      answerColor.clear();
      updateProgress();
    } else {
      // Complete the game
      await completeGame();
    }
  }
  
  Future<void> completeGame() async {
    String? userId = FirebaseService.currentUserId;
    if (userId != null) {
      // Calculate final score
      int finalScore = (score.value / questions.length * 100).round();
      
      // Update fill blanks game completion with automatic unlocking
      await FirebaseService.updateActivityCompletion(
        userId,
        categoryId,
        'games', // activity type
        finalScore,
        10, // timeSpent - approximate time spent
        gameType: 'fillInBlanks',
      );
      
      playSound('audio/levelup.mp3');
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Navigate to success screen
      Get.toNamed(Routes.FILLSUCCESS, arguments: {
        'score': finalScore,
        'correctAnswers': score.value,
        'totalQuestions': questions.length,
        'categoryName': categoryName,
      });
    }
  }

  void updateProgress() {
    if (questions.isNotEmpty) {
      progress.value = (currentIndex.value + 1) / questions.length;
    }
  }
  
  FillBlankQuestion? get currentQuestion {
    if (questions.isNotEmpty && currentIndex.value < questions.length) {
      return questions[currentIndex.value];
    }
    return null;
  }

  @override
  void onClose() {
    swipeController.dispose();
    _audioPlayer.dispose();
    super.onClose();
  }
}
