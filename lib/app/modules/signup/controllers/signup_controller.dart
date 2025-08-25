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

    // Build the Firestore user document with the required structure
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'profile': {
        'displayName': nameController.text.trim(),
        'email': emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'preferredLanguage': 'en', // default, can be updated later
        'fcmToken': '', // will update once device gets FCM token
      },
      'settings': {
        'notificationsEnabled': true,
        'dailyGoal': 10, // default daily goal
        'reminderTime': '20:00', // default reminder time
        'soundEnabled': true,
      },
      'stats': {
        'currentStreak': 0,
        'longestStreak': 0,
        'totalWordsLearned': 0,
        'totalTimeSpent': 0,
        'lastActiveDate': '', // YYYY-MM-DD string
      },
      'dailyStats': {}, // empty, will be filled when user starts activity
    });

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
    Get.snackbar("Error", e.toString());
  } finally {
    loader.value = false;
  }
}

}