import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/models/category_model.dart';
import 'package:mandarinapp/app/models/level_model.dart';
import 'package:mandarinapp/app/helper/responsive.dart';

import '../controllers/vocabulary_controller.dart';

class VocabularyView extends GetView<VocabularyController> {
  const VocabularyView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Obx(()
        => Scaffold(
          appBar: AppBar(
            backgroundColor: scaffoldColor,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              'vocabulary'.tr,
              style: TextStyle(fontSize: Responsive.sp(context, 20), fontWeight: FontWeight.bold),
            ),
            actions: [
              // IconButton(
              //   onPressed: () {
              //     controller.toggleSearch();
              //   },
              //   icon: Icon(Icons.search, size: Responsive.isTablet(context) ? 26 : 24),
              // ),
            ],
            bottom:  controller.isLoading.value
                ? PreferredSize(
                    preferredSize: Size.fromHeight(4),
                    child: LinearProgressIndicator(color: primaryColor),
                  )
                : controller.levels.isEmpty
                    ? PreferredSize(preferredSize: Size.zero, child: SizedBox.shrink())
                    : PreferredSize(
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
                            onTap: controller.onTabChanged,
                            tabs: controller.levels.map((level) {
                              return Tab(
                                child: Text(
                                  level.name.tr,
                                  style: TextStyle(fontSize: Responsive.sp(context, 14)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      )),
          
          body: Obx(() => controller.isLoading.value
              ? Center(child: CircularProgressIndicator(color: primaryColor))
              : controller.levels.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No levels available',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : TabBarView(
                      controller: controller.tabController,
                      children: controller.levels.map((level) => RefreshIndicator(
                        color: primaryColor,
                        onRefresh: () => controller.loadData(),
                        child: _buildLevelTab(level))).toList(),
                    )),
        ),
      ),
    );
  }

  Widget _buildLevelTab(LevelModel level) {
    return Obx(() {
      List<CategoryModel> categories = controller.categoriesByLevel[level.levelId] ?? [];
      bool isLevelUnlocked = controller.isLevelUnlocked(level.levelId);
      
      if (!isLevelUnlocked) {
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

      if (categories.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.category_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No categories available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          bool isUnlocked = controller.isCategoryUnlocked(category.categoryId);
          double progress = controller.getCategoryProgress(category.categoryId);
          
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
                category.nameEn.isNotEmpty ? category.nameEn : category.name,
                style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${category.totalWords} words',
                style: TextStyle(fontSize: Responsive.sp(context, 12), color: Colors.grey[600]),
              ),
              leading: Icon(
                controller.getCategoryIcon(category.name),
                color: isUnlocked ? primaryColor : Colors.grey,
                size: Responsive.isTablet(context) ? 38 : 24,
              ),
              trailing: !isUnlocked
                  ? Icon(Icons.lock_outline, color: Colors.grey, size: Responsive.isTablet(context) ? 32 : 20)
                  : SizedBox(
                      width: Responsive.isTablet(context) ? 44 : 30,
                      height: Responsive.isTablet(context) ? 44 : 30,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: progress / 100,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                            strokeWidth: Responsive.isTablet(context) ? 3.0 : 2.5,
                          ),
                          Text(
                            '${progress.toInt()}%',
                            style: TextStyle(
                              fontSize: Responsive.sp(context, 10),
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
              onTap: () => controller.navigateToChooseActivity(category),
            ),
          );
        },
      );
    });
  }
}
