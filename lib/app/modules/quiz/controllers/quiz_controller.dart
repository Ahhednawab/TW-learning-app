import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/models/word_model.dart';
import 'package:mandarinapp/app/models/quiz_session_model.dart';
import 'package:mandarinapp/app/models/user_progress_model.dart';
import 'package:mandarinapp/app/services/firebase_service.dart';
import 'dart:math';


class QuizController extends GetxController {
  // Quiz session data
  String categoryId = '';
  String levelId = '';
  String categoryName = '';
  
  // Observable variables
  var currentIndex = 0.obs;
  var progress = 0.0.obs;
  var correctCount = 0.obs;
  var selectedOption = (-1).obs;
  var isLoading = true.obs;
  
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // Store color states for each option
  var answerColor = <int, dynamic>{}.obs;
  
  // Quiz data
  final RxList<QuizQuestion> questions = <QuizQuestion>[].obs;
  final RxList<WordModel> allWords = <WordModel>[].obs;
  
  // Quiz session tracking
  String? currentSessionId;
  DateTime? sessionStartTime;
  
  @override
  void onInit() {
    super.onInit();
    
    // Get arguments from navigation
    final args = Get.arguments;
    if (args != null) {
      categoryId = args['categoryId'] ?? '';
      levelId = args['levelId'] ?? '';
      categoryName = args['categoryName'] ?? 'Quiz';
    }
    
    loadQuizData();
  }
  
  Future<void> loadQuizData() async {
    try {
      isLoading.value = true;
      
      // Load words for this category
      List<WordModel> words = await FirebaseService.getRandomWordsByCategory(categoryId, 10);
      allWords.value = words;
      
      if (words.isNotEmpty) {
        // Generate quiz questions from words
        await generateQuizQuestions(words);
        
        // Create quiz session
        await createQuizSession();
        
        // Initialize progress
        updateProgress();
      }
    } catch (e) {
      print('Error loading quiz data: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> generateQuizQuestions(List<WordModel> words) async {
    List<QuizQuestion> generatedQuestions = [];
    
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
      for (int k = 0; k < optionWords.length; k++) {
        String optionLetter = String.fromCharCode(65 + k); // A, B, C, D
        options.add('$optionLetter. ${optionWords[k].traditional} (${optionWords[k].pinyin})');
      }
      
      generatedQuestions.add(QuizQuestion(
        wordId: correctWord.wordId,
        imageUrl: correctWord.imageUrl,
        description: correctWord.english,
        options: options,
        correctIndex: correctIndex,
        correctWord: correctWord,
      ));
    }
    
    questions.value = generatedQuestions;
  }
  
  Future<void> createQuizSession() async {
    String? userId = FirebaseService.currentUserId;
    if (userId != null && questions.isNotEmpty) {
      sessionStartTime = DateTime.now();
      
      List<QuizQuestion> quizQuestions = questions.map((q) => QuizQuestion.forSession(
        wordId: q.wordId,
        question: q.description,
        options: q.options,
        correctAnswer: q.correctIndex,
        userAnswer: -1,
        isCorrect: false,
      )).toList();
      
      QuizSessionModel session = QuizSessionModel(
        sessionId: '',
        userId: userId,
        categoryId: categoryId,
        // l: levelId,
        activityType: 'quiz',
        questions: [],
        currentQuestionIndex: 0,
        totalQuestions: quizQuestions.length,
        status: 'in-progress',
        score: 0,
        startedAt: sessionStartTime!,
        timeSpent: 0,
        completedAt: null,
      );
      
      currentSessionId = await FirebaseService.createQuizSession(session);
    }
  }



  void playSound(String filePath) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(filePath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
  
  Future<void> selectOption(int index) async {
    if (selectedOption.value != -1 || questions.isEmpty) return; // Prevent double tap
    selectedOption.value = index;
    
    bool isCorrect = index == questions[currentIndex.value].correctIndex;
    
    if (isCorrect) {
      answerColor[index] = const Color(0xFFD0F0C0); // green
      playSound('audio/correct.mp3');
      correctCount.value++;
    } else {
      answerColor[index] = const Color(0xFFF4C2C2); // red
      int correct = questions[currentIndex.value].correctIndex;
      playSound('audio/failure.mp3');
      answerColor[correct] = const Color(0xFFD0F0C0); // show correct
    }
    
    // Update quiz session with answer
    await updateQuizSession(index, isCorrect);
    
    // Update word progress
    await updateWordProgress(isCorrect);
    
    // Delay before moving to next question
    Future.delayed(const Duration(milliseconds: 1500), nextQuestion);
  }
  
  Future<void> updateQuizSession(int selectedIndex, bool isCorrect) async {
    if (currentSessionId != null && questions.isNotEmpty) {
      String? userId = FirebaseService.currentUserId;
      if (userId != null) {
        // Update the specific question in the session
        QuizQuestion updatedQuestion = QuizQuestion.forSession(
          wordId: questions[currentIndex.value].wordId,
          question: questions[currentIndex.value].description,
          options: questions[currentIndex.value].options,
          correctAnswer: questions[currentIndex.value].correctIndex,
          userAnswer: selectedIndex,
          isCorrect: isCorrect,
        );
        
        await FirebaseService.updateQuizSession(
          QuizSessionModel(sessionId: currentSessionId!, userId: userId, categoryId: categoryId, activityType: 'quiz', questions: [], status: 'in-progress', score: correctCount.value, totalQuestions: questions.length, currentQuestionIndex: currentIndex.value, startedAt: sessionStartTime!, timeSpent: 0)
          // userId, 
          // currentSessionId!, 
          // currentIndex.value, 
          // updatedQuestion
        );
      }
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
        isFavorite: false, // Keep existing favorite status
      );
      
      await FirebaseService.updateWordProgress(userId, categoryId, currentWord.wordId, wordProgress);
    }
  }
  
  void passQuestion() async {
    // Mark as skipped and move to next
    selectedOption.value = -2; // Special value for skipped
    await updateQuizSession(-1, false); // -1 indicates skipped
    
    Future.delayed(const Duration(milliseconds: 300), nextQuestion);
  }
  
  void nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
      selectedOption.value = -1;
      answerColor.clear();
      updateProgress();
    } else {
      // Complete the quiz
      completeQuiz();
    }
  }
  
  Future<void> completeQuiz() async {
    if (currentSessionId != null && sessionStartTime != null) {
      String? userId = FirebaseService.currentUserId;
      if (userId != null) {
        // Calculate final score and time
        int finalScore = (correctCount.value / questions.length * 100).round();
        int timeSpent = DateTime.now().difference(sessionStartTime!).inMinutes;
        
        // Update quiz session as completed
        await FirebaseService.updateQuizSession(
          QuizSessionModel(sessionId: currentSessionId!, userId: userId, categoryId: categoryId, activityType: 'quiz', questions: [], status: 'completed', score: finalScore, totalQuestions: questions.length, currentQuestionIndex: currentIndex.value, startedAt: sessionStartTime!, timeSpent: timeSpent)
        );
        
        // Update activity progress
        ActivityProgress activityProgress = ActivityProgress(
          isCompleted: true,
          completedAt: DateTime.now(),
          score: finalScore,
          timeSpent: timeSpent,
        );
        
        await FirebaseService.updateActivityProgress(userId, categoryId, 'quiz', activityProgress);
        
        // Navigate to success screen
        Get.offNamed('/success', arguments: {
          'score': finalScore,
          'correctAnswers': correctCount.value,
          'totalQuestions': questions.length,
          'categoryName': categoryName,
        });
      }
    }
  }
  
  void updateProgress() {
    if (questions.isNotEmpty) {
      progress.value = (currentIndex.value + 1) / questions.length;
    }
  }
  
  QuizQuestion? get currentQuestion {
    if (questions.isNotEmpty && currentIndex.value < questions.length) {
      return questions[currentIndex.value];
    }
    return null;
  }
  
  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}

// Updated QuizQuestion class to work with Firestore
class QuizQuestion {
  final String wordId;
  final String imageUrl;
  final String description;
  final List<String> options;
  final int correctIndex;
  final WordModel correctWord;
  
  // For Firestore quiz session
  final String? question;
  final int? correctAnswer;
  final int? userAnswer;
  final bool? isCorrect;
  
  QuizQuestion({
    required this.wordId,
    required this.imageUrl,
    required this.description,
    required this.options,
    required this.correctIndex,
    required this.correctWord,
    this.question,
    this.correctAnswer,
    this.userAnswer,
    this.isCorrect,
  });
  
  // Constructor for Firestore quiz session questions
  QuizQuestion.forSession({
    required this.wordId,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.userAnswer,
    required this.isCorrect,
  }) : imageUrl = '',
       description = question ?? '',
       correctIndex = correctAnswer ?? 0,
       correctWord = WordModel(
         wordId: wordId,
         categoryId: '',
         levelId: '',
         isActive: false,
         tags: [],
         traditional: '',
         simplified: '',
         pinyin: '',
         english: '',
         partOfSpeech: '',
         difficulty: 1,
         imageUrl: '',
         audioUrl: '',
         exampleSentence: ExampleSentence(
           traditional: '',
           pinyin: '',
           english: '',
         ),
         createdAt: DateTime.now(),
       );
}
