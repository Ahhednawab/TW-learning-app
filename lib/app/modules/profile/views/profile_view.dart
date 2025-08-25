import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/modules/profile/widgets/profile_header.dart';
import 'package:mandarinapp/app/modules/profile/widgets/profile_section_header.dart';
import 'package:mandarinapp/app/modules/profile/widgets/profile_list_tile.dart';
import 'package:mandarinapp/app/routes/app_pages.dart';
import '../controllers/profile_controller.dart';
import 'package:mandarinapp/app/helper/responsive.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back arrow and header
            // Padding(
            //   padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            //   child: Row(
            //     children: [
            //       InkWell(
            //         borderRadius: BorderRadius.circular(24),
            //         onTap: () => Get.back(),
            //         child: const Icon(
            //           Icons.arrow_back_ios_new_rounded,
            //           size: 28,
            //           color: Colors.black,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: Responsive.isTablet(context) ? 66 : 48),
            // Profile header
            Obx(() => controller.isLoading.value
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : ProfileHeader(
                    avatarUrl: 'assets/images/profile.png',
                    userName: controller.currentUser.value?.profile.displayName ?? 'User',
                    learnedWords: controller.totalWordsLearned.value,
                    onEdit: () {
                      Get.toNamed(Routes.EDITPROFILE);
                    },
                  )),
            const SizedBox(height: 16),
            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: lightgreyColor, thickness: 1),
            ),
            const SizedBox(height: 8),
            // GENERAL section
            ProfileSectionHeader(title: 'general'.tr),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ProfileListTile(
                      icon: Icons.language,
                      label: 'language'.tr,
                      trailing: const Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: Colors.black,
                      ),
                      onTap: () {
                        controller.showLanguageSelectionDialog();
                      },
                    ),
                    Divider(height: 1, color: lightgreyColor),
                    ProfileListTile(
                      icon: Icons.notifications_none_rounded,
                      label: 'notifications'.tr,
                      trailing: Obx(
                        ()=> Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            value: controller.isNotificationEnabled.value,
                            onChanged: (v) {
                              controller.toggleNotification(v);
                            },
                            activeTrackColor: primaryColor,
                            inactiveTrackColor: lightgreyColor,
                          ),
                        ),
                      ),
                      onTap: null,
                    ),
                  ],
                ),
              ),
            ),
            // OTHERS section
             ProfileSectionHeader(title: 'others'.tr),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ProfileListTile(
                      icon: Icons.star_border_rounded,
                      label: 'rateapp'.tr,
                      trailing: null,
                      onTap: () {},
                    ),
                    Divider(height: 1, color: lightgreyColor),
                    ProfileListTile(
                      icon: Icons.edit_document,
                      label: 'reportproblem'.tr,
                      trailing: null,
                      onTap: () {},
                    ),
                    Divider(height: 1, color: lightgreyColor),
                    ProfileListTile(
                      icon: Icons.logout,
                      label: 'Logout',
                      trailing: null,
                      onTap: controller.logout,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
  }
}
