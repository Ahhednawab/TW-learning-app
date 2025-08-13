import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/routes/app_pages.dart';

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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  
                },
                icon: const Icon(Icons.search),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
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
                        return Tab(text: category.name.tr);
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
          height: 120,
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
              const Icon(Icons.lock_outline, size: 38, color: primaryColor),
              const SizedBox(height: 8),
              Text(
                'passquiz'.tr,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            tileColor: Colors.white,
            title: Text(product.name),
            leading: Icon(product.icon ?? Icons.category, color: Colors.purple),
            // Displaying progress as a percentage with rounded progress
            trailing:
                product.progress == 0
                    ? Icon(Icons.lock_outline, color: primaryColor)
                    : SizedBox(
                      width: 30,
                      height: 30,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: product.progress ?? 0.0,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              primaryColor,
                            ),
                            strokeWidth: 2.5,
                          ),
                          Text(
                            '${((product.progress ?? 0.0) * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 9,
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
