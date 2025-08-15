import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/routes/app_pages.dart';
import 'package:mandarinapp/app/helper/responsive.dart';

import '../controllers/vocabulary_controller.dart';

class VocabularyView extends GetView<VocabularyController> {
  const VocabularyView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: DefaultTabController(
        length: controller.categories.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: scaffoldColor,
            centerTitle: true,
            title: Text(
              'vocabulary'.tr,
              style: TextStyle(fontSize: Responsive.sp(context, 20), fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  
                },
                icon: Icon(Icons.search, size: Responsive.isTablet(context) ? 26 : 24),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(Responsive.isTablet(context) ? 56 : 48),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                controller: controller.categoryScrollController,
                child: TabBar(
                  isScrollable: true,
                  controller: controller.tabController,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: primaryColor,
                  labelColor: primaryColor,
                  dividerColor: Colors.transparent,
                  tabs:
                      controller.categories.map((category) {
                        return Tab(child: Text(category.name.tr, style: TextStyle(fontSize: Responsive.sp(context, 14))));
                      }).toList(),
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: controller.tabController,
            children: [
              ...controller.categories
                  .map((category) => _buildCategoryTab(category))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTab(Category category) {
    // Just filtering by category name for demo
    final filteredProducts =
        controller.allProducts.where((product) {
          // You can add category field to Product and compare here
          return product.category?.name == category.name;
        }).toList();

    if (filteredProducts.isEmpty) {
      return Center(
        child: Container(
          height: Responsive.isTablet(Get.context!) ? 140 : 120,
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: primaryColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: Responsive.isTablet(Get.context!) ? 44 : 38, color: primaryColor),
              const SizedBox(height: 8),
              Text(
                'passquiz'.tr,
                style: TextStyle(fontSize: Responsive.sp(Get.context!, 16), fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: Responsive.isTablet(context) ? 16 : 8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            tileColor: Colors.white,
            title: Text(
              product.name,
              style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.w600),
            ),
            leading: Icon(
              product.icon ?? Icons.category,
              color: Colors.purple,
              size: Responsive.isTablet(context) ? 38 : 24,
            ),
            // Displaying progress as a percentage with rounded progress
            trailing:
                product.progress == 0
                    ? Icon(Icons.lock_outline, color: primaryColor, size: Responsive.isTablet(context) ? 32 : 20)
                    : SizedBox(
                      width: Responsive.isTablet(context) ? 44 : 30,
                      height: Responsive.isTablet(context) ? 44 : 30,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: product.progress ?? 0.0,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              primaryColor,
                            ),
                            strokeWidth: Responsive.isTablet(context) ? 3.0 : 2.5,
                          ),
                          Text(
                            '${((product.progress ?? 0.0) * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: Responsive.sp(context, 10),
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

            onTap: () {
              if (product.progress == 0) {
                Get.snackbar(
                  'locked'.tr,
                  'lockedinfo'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.white,
                  colorText: primaryColor,
                );
                return;
              }
              Get.toNamed(
                Routes.CHOOSEACTIVITY,
                arguments: {'activity': category.name},
              );
            },
          ),
        );
      },
    );
  }
}
