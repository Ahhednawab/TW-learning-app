import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/modules/bottomnav/controllers/bottomnav_controller.dart';
import 'package:mandarinapp/app/widgets/CustomAppBar.dart';
import '../controllers/favorites_controller.dart';
import 'package:mandarinapp/app/helper/responsive.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: customAppBar(title: 'favoritewords', implyleading: true),
        body: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'myfavorites'.tr,
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 16),
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.find<BottomnavController>().changeTabIndex(1);
                    },
                    child: Text(
                      'takeaquiz'.tr,
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 14),
                        color: primaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: primaryColor,
                        decorationThickness: 1.5,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.isTablet(context) ? 4 : 3,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: controller.favorites.length,
                  itemBuilder: (context, index) {
                    final favorite = controller.favorites[index];
                    return Column(
                      children: [
                        Container(
                          height: Responsive.isTablet(context) ? 160 : 130,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                Image.asset(
                                  favorite.image,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                                Container(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  padding: const EdgeInsets.all(12),
                                  child: Center(
                                    child: Text(
                                      favorite.word,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Responsive.sp(context, 14),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          favorite.meaning,
                          style: TextStyle(fontSize: Responsive.sp(context, 13)),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
