import 'package:cached_network_image/cached_network_image.dart';
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
                child: Obx(() => controller.isLoading.value
                    ? Center(child: CircularProgressIndicator(color: primaryColor))
                    : !controller.hasFavorites
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  'No favorite words yet',
                                  style: TextStyle(fontSize: 18, color: Colors.grey),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Add words to favorites while learning',
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: controller.refreshFavorites,
                            child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: Responsive.isTablet(context) ? 4 : 3,
                                childAspectRatio: 0.65,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: controller.favoriteWords.length,
                              itemBuilder: (context, index) {
                                final word = controller.favoriteWords[index];
                                return GestureDetector(
                                  onLongPress: () {
                                    Get.dialog(
                                      AlertDialog(
                                        title: Text('Remove from Favorites'),
                                        content: Text('Remove "${word.traditional}" from favorites?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Get.back(),
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                              controller.removeFromFavorites(word.wordId);
                                            },
                                            child: Text('Remove', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Column(
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
                                              word.imageUrl.isNotEmpty
                                                  ? CachedNetworkImage(
                                                      imageUrl: word.imageUrl,
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      errorWidget: (context, error, stackTrace) {
                                                        return Container(
                                                          color: primaryColor.withValues(alpha: 0.1),
                                                          child: Icon(
                                                            Icons.favorite,
                                                            size: 48,
                                                            color: primaryColor,
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : Container(
                                                      color: primaryColor.withValues(alpha: 0.1),
                                                      child: Icon(
                                                        Icons.favorite,
                                                        size: 48,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                              Container(
                                                color: Colors.black.withValues(alpha: 0.6),
                                                padding: const EdgeInsets.all(12),
                                                child: Center(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        word.traditional,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: Responsive.sp(context, 16),
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      Text(
                                                        word.pinyin,
                                                        style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: Responsive.sp(context, 12),
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        word.english,
                                        style: TextStyle(fontSize: Responsive.sp(context, 13)),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
