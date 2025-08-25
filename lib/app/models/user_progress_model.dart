import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityProgress {
  final bool isCompleted;
  final DateTime? completedAt;
  final int score;
  final int timeSpent;
  final int attempts;

  ActivityProgress({
    required this.isCompleted,
    this.completedAt,
    required this.score,
    required this.timeSpent,
    this.attempts = 0,
  });

  factory ActivityProgress.fromMap(Map<String, dynamic> map) {
    return ActivityProgress(
      isCompleted: map['isCompleted'] ?? false,
      completedAt: map['completedAt'] != null 
          ? (map['completedAt'] as Timestamp).toDate() 
          : null,
      score: map['score'] ?? 0,
      timeSpent: map['timeSpent'] ?? 0,
      attempts: map['attempts'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isCompleted': isCompleted,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'score': score,
      'timeSpent': timeSpent,
      'attempts': attempts,
    };
  }
}

class GameProgress {
  final ActivityProgress fillInBlanks;
  final ActivityProgress characterMatching;
  final ActivityProgress listening;

  GameProgress({
    required this.fillInBlanks,
    required this.characterMatching,
    required this.listening,
  });

  factory GameProgress.fromMap(Map<String, dynamic> map) {
    return GameProgress(
      fillInBlanks: ActivityProgress.fromMap(map['fillInBlanks'] ?? {}),
      characterMatching: ActivityProgress.fromMap(map['characterMatching'] ?? {}),
      listening: ActivityProgress.fromMap(map['listening'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fillInBlanks': fillInBlanks.toMap(),
      'characterMatching': characterMatching.toMap(),
      'listening': listening.toMap(),
    };
  }
}

class Activities {
  final ActivityProgress swipeCards;
  final ActivityProgress quiz;
  final GameProgress games;

  Activities({
    required this.swipeCards,
    required this.quiz,
    required this.games,
  });

  factory Activities.fromMap(Map<String, dynamic> map) {
    return Activities(
      swipeCards: ActivityProgress.fromMap(map['swipeCards'] ?? {}),
      quiz: ActivityProgress.fromMap(map['quiz'] ?? {}),
      games: GameProgress.fromMap(map['games'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'swipeCards': swipeCards.toMap(),
      'quiz': quiz.toMap(),
      'games': games.toMap(),
    };
  }
}

class WordProgress {
  final String knownStatus; // "unknown", "learning", "known"
  final DateTime lastReviewed;
  final int reviewCount;
  final int correctAnswers;
  final int totalAnswers;
  final bool isFavorite;

  WordProgress({
    required this.knownStatus,
    required this.lastReviewed,
    required this.reviewCount,
    required this.correctAnswers,
    required this.totalAnswers,
    required this.isFavorite,
  });

  factory WordProgress.fromMap(Map<String, dynamic> map) {
    return WordProgress(
      knownStatus: map['knownStatus'] ?? 'unknown',
      lastReviewed: (map['lastReviewed'] as Timestamp).toDate(),
      reviewCount: map['reviewCount'] ?? 0,
      correctAnswers: map['correctAnswers'] ?? 0,
      totalAnswers: map['totalAnswers'] ?? 0,
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'knownStatus': knownStatus,
      'lastReviewed': Timestamp.fromDate(lastReviewed),
      'reviewCount': reviewCount,
      'correctAnswers': correctAnswers,
      'totalAnswers': totalAnswers,
      'isFavorite': isFavorite,
    };
  }
}

class CategoryProgress {
  final bool isUnlocked;
  final double completionPercentage;
  final Activities activities;
  final Map<String, WordProgress> wordsProgress;

  CategoryProgress({
    required this.isUnlocked,
    required this.completionPercentage,
    required this.activities,
    required this.wordsProgress,
  });

  factory CategoryProgress.fromMap(Map<String, dynamic> map) {
    Map<String, WordProgress> wordsProgressMap = {};
    if (map['wordsProgress'] != null) {
      (map['wordsProgress'] as Map<String, dynamic>).forEach((key, value) {
        wordsProgressMap[key] = WordProgress.fromMap(value);
      });
    }

    return CategoryProgress(
      isUnlocked: map['isUnlocked'] ?? false,
      completionPercentage: (map['completionPercentage'] ?? 0.0).toDouble(),
      activities: Activities.fromMap(map['activities'] ?? {}),
      wordsProgress: wordsProgressMap,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> wordsProgressMap = {};
    wordsProgress.forEach((key, value) {
      wordsProgressMap[key] = value.toMap();
    });

    return {
      'isUnlocked': isUnlocked,
      'completionPercentage': completionPercentage,
      'activities': activities.toMap(),
      'wordsProgress': wordsProgressMap,
    };
  }
}

class LastQuizAttempt {
  final String categoryId;
  final String activityType;
  final int questionIndex;
  final DateTime timestamp;
  final List<Map<String, dynamic>> answers;

  LastQuizAttempt({
    required this.categoryId,
    required this.activityType,
    required this.questionIndex,
    required this.timestamp,
    required this.answers,
  });

  factory LastQuizAttempt.fromMap(Map<String, dynamic> map) {
    return LastQuizAttempt(
      categoryId: map['categoryId'] ?? '',
      activityType: map['activityType'] ?? '',
      questionIndex: map['questionIndex'] ?? 0,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      answers: List<Map<String, dynamic>>.from(map['answers'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'activityType': activityType,
      'questionIndex': questionIndex,
      'timestamp': Timestamp.fromDate(timestamp),
      'answers': answers,
    };
  }
}

class UserProgressModel {
  final String userId;
  final String currentLevel;
  final List<String> unlockedLevels;
  final LastQuizAttempt? lastQuizAttempt;
  final Map<String, CategoryProgress> categories;
  final DateTime updatedAt;

  UserProgressModel({
    required this.userId,
    required this.currentLevel,
    required this.unlockedLevels,
    this.lastQuizAttempt,
    required this.categories,
    required this.updatedAt,
  });

  factory UserProgressModel.fromMap(String userId, Map<String, dynamic> map) {
    Map<String, CategoryProgress> categoriesMap = {};
    if (map['categories'] != null) {
      (map['categories'] as Map<String, dynamic>).forEach((key, value) {
        categoriesMap[key] = CategoryProgress.fromMap(value);
      });
    }

    return UserProgressModel(
      userId: userId,
      currentLevel: map['currentLevel'] ?? '',
      unlockedLevels: List<String>.from(map['unlockedLevels'] ?? []),
      lastQuizAttempt: map['lastQuizAttempt'] != null 
          ? LastQuizAttempt.fromMap(map['lastQuizAttempt']) 
          : null,
      categories: categoriesMap,
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> categoriesMap = {};
    categories.forEach((key, value) {
      categoriesMap[key] = value.toMap();
    });

    return {
      'currentLevel': currentLevel,
      'unlockedLevels': unlockedLevels,
      'lastQuizAttempt': lastQuizAttempt?.toMap(),
      'categories': categoriesMap,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
