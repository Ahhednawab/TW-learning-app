import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/routes/app_pages.dart';
import 'package:mandarinapp/app/services/Snackbarservice.dart';


class LoginController extends GetxController {
  RxBool obscureText = true.obs;
  RxBool loader = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }

  void signInWithEmailAndPassword() async {
    try {
      loader.value = true;

     
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Get.offAllNamed(Routes.BOTTOMNAV);

      SnackbarService.showSuccess(title: "Success", message: "Login Success");
    } on FirebaseAuthException catch (e) {
      loader.value = false;

      // Check for specific FirebaseAuthException codes
      if (e.code == 'user-not-found') {
        SnackbarService.showError(
          title: "Error",
          message: 'No user found for that email.',
        );
      } else if (e.code == 'wrong-password') {
        SnackbarService.showError(
          title: "Error",
          message: 'Wrong password provided for that user.',
        );
        // Only clear the password field on wrong-password error
      } else if (e.code == 'user-disabled') {
        SnackbarService.showError(
          title: "Error",
          message: 'This user account has been disabled.',
        );
      } else if (e.code == 'invalid-email') {
        SnackbarService.showError(
          title: "Error",
          message: 'The email address is not valid.',
        );
      } else {
        SnackbarService.showError(
          title: "Error",
          message: 'An unexpected error occurred. Please try again later.',
        );
      }
    } catch (e) {
      SnackbarService.showError(
        title: "Error",
        message: 'An unexpected error occurred. Please try again later.',
      );
    } finally {
      loader.value = false;
    }
  }

  void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
     // Get.offAll(() => const LoginPage());

      SnackbarService.showSuccess(title: "Success", message: "Logout successfully");
    } catch (e) {
      SnackbarService.showError(title: "Error", message: "Failed to sign out: $e");

    }
  }
}