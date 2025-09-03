import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/services/Snackbarservice.dart';
import '../../../models/user_model.dart';
import '../../../services/firebase_service.dart';

class EditprofileController extends GetxController {
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = true.obs;
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      String? userId = FirebaseService.currentUserId;
      
      if (userId != null) {
        UserModel? user = await FirebaseService.getUserData(userId);
        if (user != null) {
          currentUser.value = user;
          nameController.text = user.profile.displayName;
          emailController.text = user.profile.email;
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String get userName => currentUser.value?.profile.displayName ?? 'User';
  String get userEmail => currentUser.value?.profile.email ?? '';
  String get userInitial => userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

  void showEditNameBottomSheet() {
    nameController.text = userName;
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'editname'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'name'.tr,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('cancel'.tr),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => updateName(),
                  child: Text('save'.tr),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void showEditEmailBottomSheet() {
    emailController.text = userEmail;
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'editemail'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'email'.tr,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('cancel'.tr),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => updateEmail(),
                  child: Text('save'.tr),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> updateName() async {
    try {
      String newName = nameController.text.trim();
      if (newName.isEmpty) {
        SnackbarService.showError(title: 'Error', message: 'Please enter a name');
        return;
      }

      String? userId = FirebaseService.currentUserId;
      if (userId != null && currentUser.value != null) {
        // Create updated profile with new name
        UserProfile updatedProfile = UserProfile(
          displayName: newName,
          email: currentUser.value!.profile.email,
          createdAt: currentUser.value!.profile.createdAt,
          lastLoginAt: currentUser.value!.profile.lastLoginAt,
          preferredLanguage: currentUser.value!.profile.preferredLanguage,
          fcmToken: currentUser.value!.profile.fcmToken,
        );
        
        await FirebaseService.updateUserProfile(userId, updatedProfile);
        
        // Reload user data to reflect changes
        await loadUserData();
        
        Get.back();
        SnackbarService.showSuccess(title: 'Success', message: 'Name updated successfully');
      }
    } catch (e) {
      print('Error updating name: $e');
      SnackbarService.showError(title: 'Error', message: 'Failed to update name');
    }
  }

  Future<void> updateEmail() async {
    try {
      String newEmail = emailController.text.trim();
      if (newEmail.isEmpty || !GetUtils.isEmail(newEmail)) {
        SnackbarService.showError(title: 'Error', message: 'Please enter a valid email');
        return;
      }

      String? userId = FirebaseService.currentUserId;
      if (userId != null && currentUser.value != null) {
        // Create updated profile with new email
        UserProfile updatedProfile = UserProfile(
          displayName: currentUser.value!.profile.displayName,
          email: newEmail,
          createdAt: currentUser.value!.profile.createdAt,
          lastLoginAt: currentUser.value!.profile.lastLoginAt,
          preferredLanguage: currentUser.value!.profile.preferredLanguage,
          fcmToken: currentUser.value!.profile.fcmToken,
        );
        
        await FirebaseService.updateUserProfile(userId, updatedProfile);
        
        // Reload user data to reflect changes
        await loadUserData();
        
        Get.back();
        SnackbarService.showSuccess(title: 'Success', message: 'Email updated successfully');
      }
    } catch (e) {
      print('Error updating email: $e');
      SnackbarService.showError(title: 'Error', message: 'Failed to update email');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
