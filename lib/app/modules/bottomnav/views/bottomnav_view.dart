import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/helper/responsive.dart';
import 'package:mandarinapp/app/modules/bottomnav/controllers/bottomnav_controller.dart';
import 'package:mandarinapp/app/modules/favorites/controllers/favorites_controller.dart';
import 'package:mandarinapp/app/modules/favorites/views/favorites_view.dart';
import 'package:mandarinapp/app/modules/home/controllers/home_controller.dart';
import 'package:mandarinapp/app/modules/home/views/home_view.dart';
import 'package:mandarinapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:mandarinapp/app/modules/profile/views/profile_view.dart';
import 'package:mandarinapp/app/modules/vocabulary/controllers/vocabulary_controller.dart';
import 'package:mandarinapp/app/modules/vocabulary/views/vocabulary_view.dart';

class BottomnavView extends GetView<BottomnavController> {
  final TextStyle unselectedLabelStyle = const TextStyle(
    color: whiteColor,
    fontWeight: FontWeight.w500,
    // fontSize: 12,
  );

  final TextStyle selectedLabelStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    // fontSize: 12,
  );

  const BottomnavView({super.key});

  buildBottomNavigationMenu(context, controller) {
    return Obx(
      () => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(Responsive.isTablet(context) ? 2.0 : 1.0)),
        child: Container(
          height: Responsive.isTablet(context) ? 100 : 70,
          decoration: const BoxDecoration(
            color: secondaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            unselectedFontSize: Responsive.isTablet(context) ? 16 : 12, 
            selectedFontSize: Responsive.isTablet(context) ? 16 : 12,
            onTap: controller.changeTabIndex,
            currentIndex: controller.tabIndex.value,
            backgroundColor: whiteColor,
            unselectedItemColor: greyColor,
            selectedItemColor: primaryColor,
            unselectedLabelStyle: unselectedLabelStyle,
            selectedLabelStyle: selectedLabelStyle,
            items: List.generate(
              4,
              (index) => BottomNavigationBarItem(
                icon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Indicator
                    Container(
                      height: 4,
                      width: 44,
                      decoration: BoxDecoration(
                        color:
                            controller.tabIndex.value == index
                                ? primaryColor
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ), // Space between indicator and icon
                    Icon(
                      _getIcon(index),
                      size: controller.tabIndex.value == index ? Responsive.isTablet(context) ? 40.0 : 24.0 : Responsive.isTablet(context) ? 44.0 : 20.0,
                      color:
                          controller.tabIndex.value == index
                              ? primaryColor
                              : greyColor,
                    ),
                  ],
                ),
                label: _getLabel(index).tr,
                backgroundColor: whiteColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home_outlined;
      case 1:
        return Icons.menu_book_rounded;
      case 2:
        return Icons.favorite;
      case 3:
        return Icons.person;
      default:
        return Icons.person;
    }
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return 'home';
      case 1:
        return 'vocabulary';
      case 2:
        return 'favourites';
      case 3:
        return 'profile';
      default:
        return 'profile';
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(VocabularyController());
    Get.put(ProfileController());
    Get.put(HomeController());
    Get.put(FavoritesController());
    return Scaffold(
      extendBody: true,
      backgroundColor: whiteColor,
      bottomNavigationBar: buildBottomNavigationMenu(context, controller),
      body: Obx(() {
        print(controller.tabIndex.value);
        return IndexedStack(
          index: controller.tabIndex.value,
          children: [HomeView(), VocabularyView(), FavoritesView(), ProfileView()],
        );
      }),
    );
  }
}
