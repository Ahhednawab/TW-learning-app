import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String displayName;
  final String email;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final String preferredLanguage;
  final String fcmToken;

  UserProfile({
    required this.displayName,
    required this.email,
    required this.createdAt,
    required this.lastLoginAt,
    required this.preferredLanguage,
    required this.fcmToken,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastLoginAt: (map['lastLoginAt'] as Timestamp).toDate(),
      preferredLanguage: map['preferredLanguage'] ?? 'en',
      fcmToken: map['fcmToken'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
      'preferredLanguage': preferredLanguage,
      'fcmToken': fcmToken,
    };
  }
}

class UserSettings {
  final bool notificationsEnabled;
  final int dailyGoal;
  final String reminderTime;
  final bool soundEnabled;

  UserSettings({
    required this.notificationsEnabled,
    required this.dailyGoal,
    required this.reminderTime,
    required this.soundEnabled,
  });

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      dailyGoal: map['dailyGoal'] ?? 10,
      reminderTime: map['reminderTime'] ?? '19:00',
      soundEnabled: map['soundEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'dailyGoal': dailyGoal,
      'reminderTime': reminderTime,
      'soundEnabled': soundEnabled,
    };
  }
}

class UserStats {
  final int currentStreak;
  final int longestStreak;
  final int totalWordsLearned;
  final int totalTimeSpent;
  final String lastActiveDate;

  UserStats({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalWordsLearned,
    required this.totalTimeSpent,
    required this.lastActiveDate,
  });

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      currentStreak: map['currentStreak'] ?? 0,
      longestStreak: map['longestStreak'] ?? 0,
      totalWordsLearned: map['totalWordsLearned'] ?? 0,
      totalTimeSpent: map['totalTimeSpent'] ?? 0,
      lastActiveDate: map['lastActiveDate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'totalWordsLearned': totalWordsLearned,
      'totalTimeSpent': totalTimeSpent,
      'lastActiveDate': lastActiveDate,
    };
  }
}

class DailyStats {
  final int timeSpent;
  final int wordsLearned;
  final int activitiesCompleted;
  final String lastWordReviewed;

  DailyStats({
    required this.timeSpent,
    required this.wordsLearned,
    required this.activitiesCompleted,
    required this.lastWordReviewed,
  });

  factory DailyStats.fromMap(Map<String, dynamic> map) {
    return DailyStats(
      timeSpent: map['timeSpent'] ?? 0,
      wordsLearned: map['wordsLearned'] ?? 0,
      activitiesCompleted: map['activitiesCompleted'] ?? 0,
      lastWordReviewed: map['lastWordReviewed'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timeSpent': timeSpent,
      'wordsLearned': wordsLearned,
      'activitiesCompleted': activitiesCompleted,
      'lastWordReviewed': lastWordReviewed,
    };
  }
}

class UserModel {
  final String userId;
  final UserProfile profile;
  final UserSettings settings;
  final UserStats stats;
  final Map<String, DailyStats> dailyStats;

  UserModel({
    required this.userId,
    required this.profile,
    required this.settings,
    required this.stats,
    required this.dailyStats,
  });

  factory UserModel.fromMap(String userId, Map<String, dynamic> map) {
    Map<String, DailyStats> dailyStatsMap = {};
    if (map['dailyStats'] != null) {
      (map['dailyStats'] as Map<String, dynamic>).forEach((key, value) {
        dailyStatsMap[key] = DailyStats.fromMap(value);
      });
    }

    return UserModel(
      userId: userId,
      profile: UserProfile.fromMap(map['profile'] ?? {}),
      settings: UserSettings.fromMap(map['settings'] ?? {}),
      stats: UserStats.fromMap(map['stats'] ?? {}),
      dailyStats: dailyStatsMap,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> dailyStatsMap = {};
    dailyStats.forEach((key, value) {
      dailyStatsMap[key] = value.toMap();
    });

    return {
      'profile': profile.toMap(),
      'settings': settings.toMap(),
      'stats': stats.toMap(),
      'dailyStats': dailyStatsMap,
    };
  }
}
