import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/level_model.dart';
import '../models/category_model.dart';
import '../models/word_model.dart';
import '../models/user_progress_model.dart';
import '../models/quiz_session_model.dart';
import '../models/daily_word_model.dart';
import '../models/favorite_model.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  static String? get currentUserId => _auth.currentUser?.uid;

  // User Operations
  static Future<UserModel?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(userId, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  static Future<bool> createOrUpdateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.userId).set(user.toMap(), SetOptions(merge: true));
      return true;
    } catch (e) {
      print('Error creating/updating user: $e');
      return false;
    }
  }

  static Future<bool> updateUserProfile(String userId, UserProfile profile) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'profile': profile.toMap(),
      });
      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  static Future<bool> updateUserSettings(String userId, UserSettings settings) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'settings': settings.toMap(),
      });
      return true;
    } catch (e) {
      print('Error updating user settings: $e');
      return false;
    }
  }

  static Future<bool> updateUserStats(String userId, UserStats stats) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'stats': stats.toMap(),
      });
      return true;
    } catch (e) {
      print('Error updating user stats: $e');
      return false;
    }
  }

  static Future<bool> updateDailyStats(String userId, String date, DailyStats dailyStats) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'dailyStats.$date': dailyStats.toMap(),
      });
      return true;
    } catch (e) {
      print('Error updating daily stats: $e');
      return false;
    }
  }

  // Level Operations
  static Future<List<LevelModel>> getAllLevels() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('levels')
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();
      
      return snapshot.docs
          .map((doc) => LevelModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting levels: $e');
      return [];
    }
  }

  static Future<LevelModel?> getLevel(String levelId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('levels').doc(levelId).get();
      if (doc.exists) {
        return LevelModel.fromMap(levelId, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting level: $e');
      return null;
    }
  }

  // Category Operations
  static Future<List<CategoryModel>> getCategoriesByLevel(String levelId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('categories')
          .where('levelId', isEqualTo: levelId)
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();
      
      return snapshot.docs
          .map((doc) => CategoryModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  static Future<CategoryModel?> getCategory(String categoryId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('categories').doc(categoryId).get();
      if (doc.exists) {
        return CategoryModel.fromMap(categoryId, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting category: $e');
      return null;
    }
  }

  // Word Operations
  static Future<List<WordModel>> getWordsByCategory(String categoryId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('words')
          .where('categoryId', isEqualTo: categoryId)
          .where('isActive', isEqualTo: true)
          .get();
      
      return snapshot.docs
          .map((doc) => WordModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting words: $e');
      return [];
    }
  }

  static Future<WordModel?> getWord(String wordId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('words').doc(wordId).get();
      if (doc.exists) {
        return WordModel.fromMap(wordId, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting word: $e');
      return null;
    }
  }

  static Future<List<WordModel>> getRandomWordsByCategory(String categoryId, int limit) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('words')
          .where('categoryId', isEqualTo: categoryId)
          .where('isActive', isEqualTo: true)
          .limit(limit * 3) // Get more to randomize
          .get();
      
      List<WordModel> words = snapshot.docs
          .map((doc) => WordModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      
      words.shuffle();
      return words.take(limit).toList();
    } catch (e) {
      print('Error getting random words: $e');
      return [];
    }
  }

  // User Progress Operations
  static Future<UserProgressModel?> getUserProgress(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('userProgress').doc(userId).get();
      if (doc.exists) {
        return UserProgressModel.fromMap(userId, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user progress: $e');
      return null;
    }
  }

  static Future<bool> updateUserProgress(UserProgressModel progress) async {
    try {
      await _firestore.collection('userProgress').doc(progress.userId).set(progress.toMap(), SetOptions(merge: true));
      return true;
    } catch (e) {
      print('Error updating user progress: $e');
      return false;
    }
  }

  static Future<bool> updateCategoryProgress(String userId, String categoryId, CategoryProgress categoryProgress) async {
    try {
      await _firestore.collection('userProgress').doc(userId).update({
        'categories.$categoryId': categoryProgress.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error updating category progress: $e');
      return false;
    }
  }

  static Future<bool> updateWordProgress(String userId, String categoryId, String wordId, WordProgress wordProgress) async {
    try {
      await _firestore.collection('userProgress').doc(userId).update({
        'categories.$categoryId.wordsProgress.$wordId': wordProgress.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error updating word progress: $e');
      return false;
    }
  }

  static Future<bool> updateActivityProgress(String userId, String categoryId, String activityType, ActivityProgress activityProgress) async {
    try {
      await _firestore.collection('userProgress').doc(userId).update({
        'categories.$categoryId.activities.$activityType': activityProgress.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error updating activity progress: $e');
      return false;
    }
  }

  // Quiz Session Operations
  static Future<String?> createQuizSession(QuizSessionModel session) async {
    try {
      DocumentReference docRef = await _firestore.collection('quizSessions').add(session.toMap());
      return docRef.id;
    } catch (e) {
      print('Error creating quiz session: $e');
      return null;
    }
  }

  static Future<QuizSessionModel?> getQuizSession(String sessionId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('quizSessions').doc(sessionId).get();
      if (doc.exists) {
        return QuizSessionModel.fromMap(sessionId, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting quiz session: $e');
      return null;
    }
  }

  static Future<bool> updateQuizSession(QuizSessionModel session) async {
    try {
      await _firestore.collection('quizSessions').doc(session.sessionId).update(session.toMap());
      return true;
    } catch (e) {
      print('Error updating quiz session: $e');
      return false;
    }
  }

  static Future<List<QuizSessionModel>> getUserQuizSessions(String userId, {int limit = 10}) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('quizSessions')
          .where('userId', isEqualTo: userId)
          .orderBy('startedAt', descending: true)
          .limit(limit)
          .get();
      
      return snapshot.docs
          .map((doc) => QuizSessionModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting user quiz sessions: $e');
      return [];
    }
  }

  static Future<QuizSessionModel?> getLastIncompleteQuizSession(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('quizSessions')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'in_progress')
          .orderBy('startedAt', descending: true)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        return QuizSessionModel.fromMap(snapshot.docs.first.id, snapshot.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting last incomplete quiz session: $e');
      return null;
    }
  }

  // Daily Word Operations
  static Future<DailyWordModel?> getDailyWord(String date) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('dailyWords').doc(date).get();
      if (doc.exists) {
        return DailyWordModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting daily word: $e');
      return null;
    }
  }

  static Future<DailyWordModel?> getTodaysDailyWord() async {
    String today = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD format
    return await getDailyWord(today);
  }

  // Favorites Operations
  static Future<List<FavoriteModel>> getUserFavorites(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .orderBy('addedAt', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => FavoriteModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting user favorites: $e');
      return [];
    }
  }

  static Future<bool> addToFavorites(String userId, String wordId, String categoryId, String levelId) async {
    try {
      FavoriteModel favorite = FavoriteModel(
        wordId: wordId,
        addedAt: DateTime.now(),
        categoryId: categoryId,
        levelId: levelId,
      );
      
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(wordId)
          .set(favorite.toMap());
      
      return true;
    } catch (e) {
      print('Error adding to favorites: $e');
      return false;
    }
  }

  static Future<bool> removeFromFavorites(String userId, String wordId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(wordId)
          .delete();
      
      return true;
    } catch (e) {
      print('Error removing from favorites: $e');
      return false;
    }
  }

  static Future<bool> isWordFavorite(String userId, String wordId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(wordId)
          .get();
      
      return doc.exists;
    } catch (e) {
      print('Error checking if word is favorite: $e');
      return false;
    }
  }

  // Helper Methods
  static Future<bool> initializeUserProgress(String userId, String firstLevelId) async {
    try {
      UserProgressModel initialProgress = UserProgressModel(
        userId: userId,
        currentLevel: firstLevelId,
        unlockedLevels: [firstLevelId],
        categories: {},
        updatedAt: DateTime.now(),
      );
      
      await _firestore.collection('userProgress').doc(userId).set(initialProgress.toMap());
      return true;
    } catch (e) {
      print('Error initializing user progress: $e');
      return false;
    }
  }

  static Future<bool> unlockNextCategory(String userId, String currentCategoryId) async {
    try {
      // Get current category to find next one
      CategoryModel? currentCategory = await getCategory(currentCategoryId);
      if (currentCategory == null) return false;

      // Get all categories in the same level
      List<CategoryModel> categories = await getCategoriesByLevel(currentCategory.levelId);
      categories.sort((a, b) => a.order.compareTo(b.order));

      // Find current category index
      int currentIndex = categories.indexWhere((cat) => cat.categoryId == currentCategoryId);
      if (currentIndex == -1 || currentIndex >= categories.length - 1) {
        // This is the last category in the level, unlock next level
        return await unlockNextLevel(userId, currentCategory.levelId);
      }

      // Unlock next category
      String nextCategoryId = categories[currentIndex + 1].categoryId;
      await _firestore.collection('userProgress').doc(userId).update({
        'categories.$nextCategoryId.isUnlocked': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error unlocking next category: $e');
      return false;
    }
  }

  static Future<bool> unlockNextLevel(String userId, String currentLevelId) async {
    try {
      // Get all levels
      List<LevelModel> levels = await getAllLevels();
      levels.sort((a, b) => a.order.compareTo(b.order));

      // Find current level index
      int currentIndex = levels.indexWhere((level) => level.levelId == currentLevelId);
      if (currentIndex == -1 || currentIndex >= levels.length - 1) {
        return false; // No next level
      }

      // Unlock next level
      String nextLevelId = levels[currentIndex + 1].levelId;
      await _firestore.collection('userProgress').doc(userId).update({
        'unlockedLevels': FieldValue.arrayUnion([nextLevelId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Unlock first category of next level
      List<CategoryModel> nextLevelCategories = await getCategoriesByLevel(nextLevelId);
      if (nextLevelCategories.isNotEmpty) {
        nextLevelCategories.sort((a, b) => a.order.compareTo(b.order));
        String firstCategoryId = nextLevelCategories.first.categoryId;
        
        await _firestore.collection('userProgress').doc(userId).update({
          'categories.$firstCategoryId.isUnlocked': true,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      return true;
    } catch (e) {
      print('Error unlocking next level: $e');
      return false;
    }
  }

  // Signout
  static Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Statistics and Analytics
  static Future<Map<String, dynamic>> getUserStatistics(String userId) async {
    try {
      UserModel? user = await getUserData(userId);
      UserProgressModel? progress = await getUserProgress(userId);
      
      if (user == null || progress == null) {
        return {};
      }

      int totalCategories = 0;
      int completedCategories = 0;
      int totalActivities = 0;
      int completedActivities = 0;
      
      for (CategoryProgress categoryProgress in progress.categories.values) {
        totalCategories++;
        if (categoryProgress.completionPercentage >= 100) {
          completedCategories++;
        }
        
        // Count activities
        if (categoryProgress.activities.swipeCards.isCompleted) completedActivities++;
        if (categoryProgress.activities.quiz.isCompleted) completedActivities++;
        if (categoryProgress.activities.games.fillInBlanks.isCompleted) completedActivities++;
        if (categoryProgress.activities.games.characterMatching.isCompleted) completedActivities++;
        if (categoryProgress.activities.games.listening.isCompleted) completedActivities++;
        
        totalActivities += 5; // 5 activities per category
      }

      return {
        'totalWordsLearned': user.stats.totalWordsLearned,
        'currentStreak': user.stats.currentStreak,
        'longestStreak': user.stats.longestStreak,
        'totalTimeSpent': user.stats.totalTimeSpent,
        'totalCategories': totalCategories,
        'completedCategories': completedCategories,
        'totalActivities': totalActivities,
        'completedActivities': completedActivities,
        'completionPercentage': totalCategories > 0 ? (completedCategories / totalCategories * 100).round() : 0,
      };
    } catch (e) {
      print('Error getting user statistics: $e');
      return {};
    }
  }
}
