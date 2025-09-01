import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  static const String _streakCountKey = 'learning_streak_count';
  static const String _lastActiveKey = 'last_active_date';
  static const String _timeSpentTodayKey = 'time_spent_today';
  static const String _sessionStartKey = 'session_start_time';
  static const String _totalTimeKey = 'total_learning_time';

  // Get current learning streak
  static Future<int> getLearningStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakCountKey) ?? 0;
  }

  // Get time spent today (in minutes)
  static Future<int> getTimeSpentToday() async {
    final prefs = await SharedPreferences.getInstance();
    String today = DateTime.now().toIso8601String().split('T')[0];
    String lastDate = prefs.getString('${_timeSpentTodayKey}_date') ?? '';
    
    if (today != lastDate) {
      // New day, reset time spent
      await prefs.setInt(_timeSpentTodayKey, 0);
      await prefs.setString('${_timeSpentTodayKey}_date', today);
      return 0;
    }
    
    return prefs.getInt(_timeSpentTodayKey) ?? 0;
  }

  // Start a learning session
  static Future<void> startSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sessionStartKey, DateTime.now().millisecondsSinceEpoch);
  }

  // End a learning session and update time spent
  static Future<void> endSession() async {
    final prefs = await SharedPreferences.getInstance();
    int? sessionStart = prefs.getInt(_sessionStartKey);
    
    if (sessionStart != null) {
      int sessionDuration = DateTime.now().millisecondsSinceEpoch - sessionStart;
      int sessionMinutes = (sessionDuration / (1000 * 60)).round();
      
      // Update time spent today
      int currentTimeToday = await getTimeSpentToday();
      String today = DateTime.now().toIso8601String().split('T')[0];
      
      await prefs.setInt(_timeSpentTodayKey, currentTimeToday + sessionMinutes);
      await prefs.setString('${_timeSpentTodayKey}_date', today);
      
      // Update total time
      int totalTime = prefs.getInt(_totalTimeKey) ?? 0;
      await prefs.setInt(_totalTimeKey, totalTime + sessionMinutes);
      
      // Clear session start
      await prefs.remove(_sessionStartKey);
    }
  }

  // Update learning streak
  static Future<void> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    String today = DateTime.now().toIso8601String().split('T')[0];
    String lastActive = prefs.getString(_lastActiveKey) ?? '';
    
    if (lastActive.isEmpty) {
      // First time using app
      await prefs.setInt(_streakCountKey, 1);
      await prefs.setString(_lastActiveKey, today);
    } else {
      DateTime lastActiveDate = DateTime.parse(lastActive);
      DateTime todayDate = DateTime.parse(today);
      int daysDifference = todayDate.difference(lastActiveDate).inDays;
      
      if (daysDifference == 0) {
        // Same day, no change to streak
        return;
      } else if (daysDifference == 1) {
        // Consecutive day, increment streak
        int currentStreak = prefs.getInt(_streakCountKey) ?? 0;
        await prefs.setInt(_streakCountKey, currentStreak + 1);
        await prefs.setString(_lastActiveKey, today);
      } else {
        // Missed days, reset streak
        await prefs.setInt(_streakCountKey, 1);
        await prefs.setString(_lastActiveKey, today);
      }
    }
  }

  // Get total learning time (in minutes)
  static Future<int> getTotalLearningTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalTimeKey) ?? 0;
  }

  // Check if user is in an active session
  static Future<bool> hasActiveSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_sessionStartKey);
  }

  // Get session duration in minutes (if active)
  static Future<int> getCurrentSessionDuration() async {
    final prefs = await SharedPreferences.getInstance();
    int? sessionStart = prefs.getInt(_sessionStartKey);
    
    if (sessionStart != null) {
      int duration = DateTime.now().millisecondsSinceEpoch - sessionStart;
      return (duration / (1000 * 60)).round();
    }
    
    return 0;
  }
}
