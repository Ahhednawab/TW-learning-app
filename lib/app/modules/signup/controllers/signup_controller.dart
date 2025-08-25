import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/routes/app_pages.dart';
import 'package:mandarinapp/app/services/Snackbarservice.dart';

class SignupController extends GetxController {
  RxBool obscureText = false.obs;
  RxBool loader = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }

  void createUserWithEmailAndPassword() async {
    try {
      loader.value = true;

      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      final uid = credential.user!.uid;

      // Get the first level and first category to unlock initially
      await _initializeNewUser(uid);

      // Clear controllers
      emailController.clear();
      passwordController.clear();
      nameController.clear();

      Get.toNamed(Routes.BOTTOMNAV);
      SnackbarService.showSuccess(
        title: "Success",
        message: "Account Created Successfully",
      );
    } on FirebaseAuthException catch (e) {
      loader.value = false;
      if (e.code == 'weak-password') {
        SnackbarService.showError(
          title: "Weak Password",
          message: 'The password provided is too weak.',
        );
      } else if (e.code == 'email-already-in-use') {
        SnackbarService.showError(
          title: "Email Already Exists",
          message: 'The account already exists for that email.',
        );
      }
    } catch (e) {
      // Get.snackbar("Error", e.toString());
    } finally {
      loader.value = false;
    }
  }

  Future<void> _initializeNewUser(String uid) async {
    final firestore = FirebaseFirestore.instance;
    
    try {
      // Create user document first
      await firestore.collection('users').doc(uid).set({
        'profile': {
          'displayName': nameController.text.trim(),
          'email': emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
          'preferredLanguage': 'en',
          'fcmToken': '',
        },
        'settings': {
          'notificationsEnabled': true,
          'dailyGoal': 10,
          'reminderTime': '20:00',
          'soundEnabled': true,
        },
        'stats': {
          'currentStreak': 0,
          'longestStreak': 0,
          'totalWordsLearned': 0,
          'totalTimeSpent': 0,
          'lastActiveDate': '',
        },
        'dailyStats': {},
      });

      // Get the first level (order = 1)
      final levelsQuery = await firestore
          .collection('levels')
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .limit(1)
          .get();

      if (levelsQuery.docs.isEmpty) {
        throw Exception('No active levels found');
      }

      final firstLevel = levelsQuery.docs.first;
      final firstLevelId = firstLevel.id;

      // Get the first category in the first level (order = 1)
      final categoriesQuery = await firestore
          .collection('categories')
          .where('levelId', isEqualTo: firstLevelId)
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .limit(1)
          .get();

      if (categoriesQuery.docs.isEmpty) {
        throw Exception('No active categories found in first level');
      }

      final firstCategory = categoriesQuery.docs.first;
      final firstCategoryId = firstCategory.id;

      // Create userProgress document with first category unlocked
      await firestore.collection('userProgress').doc(uid).set({
        'currentLevel': firstLevelId,
        'unlockedLevels': [firstLevelId],
        'lastQuizAttempt': null,
        'categories': {
          firstCategoryId: {
            'isUnlocked': true, // ✅ First category is unlocked
            'completionPercentage': 0,
            'activities': {
              'swipeCards': {
                'isCompleted': false,
                'completedAt': null,
                'score': 0,
                'timeSpent': 0,
              },
              'quiz': {
                'isCompleted': false,
                'completedAt': null,
                'score': 0,
                'attempts': 0,
                'timeSpent': 0,
              },
              'games': {
                'fillInBlanks': {
                  'isCompleted': false,
                  'completedAt': null,
                  'score': 0,
                  'timeSpent': 0,
                },
                'characterMatching': {
                  'isCompleted': false,
                  'completedAt': null,
                  'score': 0,
                  'timeSpent': 0,
                },
                'listening': {
                  'isCompleted': false,
                  'completedAt': null,
                  'score': 0,
                  'timeSpent': 0,
                },
              },
            },
            'wordsProgress': {}, // Will be populated as user encounters words
          },
        },
        'updatedAt': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      // If userProgress creation fails, we should clean up the user document
      print('Failed to initialize user data: $e');
      await firestore.collection('users').doc(uid).delete();
      throw Exception('Failed to initialize user data: $e');
    }
  }
}
