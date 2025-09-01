import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import '../models/word_model.dart';
import 'firebase_service.dart';

class WordOfDayService {
  static const String _wordOfDayKey = 'word_of_day';
  static const String _wordOfDayDateKey = 'word_of_day_date';
  static const String _lastWordReviewedKey = 'last_word_reviewed';
  static const String _lastWordReviewedTimeKey = 'last_word_reviewed_time';

  // Get word of the day
  static Future<WordModel?> getWordOfDay() async {
    final prefs = await SharedPreferences.getInstance();
    String today = DateTime.now().toIso8601String().split('T')[0];
    String lastDate = prefs.getString(_wordOfDayDateKey) ?? '';

    if (today != lastDate) {
      // New day, get a new word
      WordModel? newWord = await _selectRandomWord();
      if (newWord != null) {
        await prefs.setString(_wordOfDayKey, jsonEncode(newWord.toJson()));
        await prefs.setString(_wordOfDayDateKey, today);
        return newWord;
      }
    } else {
      // Same day, return stored word
      String? wordJson = prefs.getString(_wordOfDayKey);
      if (wordJson != null) {
        try {
          Map<String, dynamic> wordMap = jsonDecode(wordJson);
          return WordModel.fromJson(wordMap); // ✅ Use fromJson, not fromMap
        } catch (e) {
          print('Error parsing stored word: $e');
        }
      }
    }

    return await _selectRandomWord();
  }

  // Select a random word from available categories
  static Future<WordModel?> _selectRandomWord() async {
    try {
      // Get all levels
      final levels = await FirebaseService.getAllLevels();
      if (levels.isEmpty) return null;

      // Get categories from first level (or random level)
      final categories = await FirebaseService.getCategoriesByLevel(
        levels.first.levelId,
      );
      if (categories.isEmpty) return null;

      // Get words from random category
      final randomCategory = categories[Random().nextInt(categories.length)];
      final words = await FirebaseService.getWordsByCategory(
        randomCategory.categoryId,
      );

      if (words.isNotEmpty) {
        return words[Random().nextInt(words.length)];
      }
    } catch (e) {
      print('Error selecting random word: $e');
    }

    return null;
  }

  // Set last word reviewed
  static Future<void> setLastWordReviewed(WordModel word) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _lastWordReviewedKey,
      jsonEncode({
        'wordId': word.wordId,
        'english': word.english,
        'traditional': word.traditional,
        'simplified': word.simplified,
        'pinyin': word.pinyin,
        'categoryId': word.categoryId,
        'levelId': word.levelId,
      }),
    );
    await prefs.setInt(
      _lastWordReviewedTimeKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  // Get last word reviewed
  static Future<Map<String, dynamic>?> getLastWordReviewed() async {
    final prefs = await SharedPreferences.getInstance();
    String? wordJson = prefs.getString(_lastWordReviewedKey);
    int? reviewTime = prefs.getInt(_lastWordReviewedTimeKey);

    if (wordJson != null && reviewTime != null) {
      try {
        return {
          'word':
              await _selectRandomWord(), // Simplified - would normally parse JSON
          'reviewTime': DateTime.fromMillisecondsSinceEpoch(reviewTime),
        };
      } catch (e) {
        print('Error parsing last reviewed word: $e');
      }
    }

    return null;
  }

  // Get time since last review in hours
  static Future<int> getHoursSinceLastReview() async {
    final prefs = await SharedPreferences.getInstance();
    int? reviewTime = prefs.getInt(_lastWordReviewedTimeKey);

    if (reviewTime != null) {
      int timeDiff = DateTime.now().millisecondsSinceEpoch - reviewTime;
      return (timeDiff / (1000 * 60 * 60)).round();
    }

    return 0;
  }

  // Clear word of day (for testing)
  static Future<void> clearWordOfDay() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_wordOfDayKey);
    await prefs.remove(_wordOfDayDateKey);
  }
}
