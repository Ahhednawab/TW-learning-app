import 'package:cloud_firestore/cloud_firestore.dart';

class QuizQuestion {
  final String wordId;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String userAnswer;
  final bool isCorrect;
  final int timeSpent;

  QuizQuestion({
    required this.wordId,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.userAnswer,
    required this.isCorrect,
    required this.timeSpent,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      wordId: map['wordId'] ?? '',
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswer: map['correctAnswer'] ?? '',
      userAnswer: map['userAnswer'] ?? '',
      isCorrect: map['isCorrect'] ?? false,
      timeSpent: map['timeSpent'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'wordId': wordId,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'userAnswer': userAnswer,
      'isCorrect': isCorrect,
      'timeSpent': timeSpent,
    };
  }
}

class QuizSessionModel {
  final String sessionId;
  final String userId;
  final String categoryId;
  final String activityType;
  final List<QuizQuestion> questions;
  final String status; // "in_progress", "completed", "abandoned"
  final int score;
  final int totalQuestions;
  final int currentQuestionIndex;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int timeSpent;

  QuizSessionModel({
    required this.sessionId,
    required this.userId,
    required this.categoryId,
    required this.activityType,
    required this.questions,
    required this.status,
    required this.score,
    required this.totalQuestions,
    required this.currentQuestionIndex,
    required this.startedAt,
    this.completedAt,
    required this.timeSpent,
  });

  factory QuizSessionModel.fromMap(String sessionId, Map<String, dynamic> map) {
    List<QuizQuestion> questionsList = [];
    if (map['questions'] != null) {
      questionsList = (map['questions'] as List)
          .map((q) => QuizQuestion.fromMap(q))
          .toList();
    }

    return QuizSessionModel(
      sessionId: sessionId,
      userId: map['userId'] ?? '',
      categoryId: map['categoryId'] ?? '',
      activityType: map['activityType'] ?? '',
      questions: questionsList,
      status: map['status'] ?? 'in_progress',
      score: map['score'] ?? 0,
      totalQuestions: map['totalQuestions'] ?? 0,
      currentQuestionIndex: map['currentQuestionIndex'] ?? 0,
      startedAt: (map['startedAt'] as Timestamp).toDate(),
      completedAt: map['completedAt'] != null 
          ? (map['completedAt'] as Timestamp).toDate() 
          : null,
      timeSpent: map['timeSpent'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'categoryId': categoryId,
      'activityType': activityType,
      'questions': questions.map((q) => q.toMap()).toList(),
      'status': status,
      'score': score,
      'totalQuestions': totalQuestions,
      'currentQuestionIndex': currentQuestionIndex,
      'startedAt': Timestamp.fromDate(startedAt),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'timeSpent': timeSpent,
    };
  }
}
