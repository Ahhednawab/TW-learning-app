import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VocabularyController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  final ScrollController categoryScrollController = ScrollController();
  var isSearching = false.obs;


  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: categories.length, vsync: this);
    tabController.addListener(scrollToSelectedTab);
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
  }

  final List<Category> categories = [
    Category(name: 'beginner'),
    Category(name: 'preintermediate'),
    Category(name: 'intermediate'),
    Category(name: 'upperintermediate'),
    Category(name: 'veteran'),
  ];

   void scrollToSelectedTab() {
    if (!categoryScrollController.hasClients) return;

    // Approximate width of each tab - adjust based on your UI or measure dynamically
    const double tabWidth = 100.0;

    // Calculate desired offset to make selected tab fully visible with some padding
    final double screenWidth = Get.width;
    final double tabCenter = tabController.index * tabWidth + tabWidth / 1.5;

    // Scroll offset to center the tab (or keep it visible)
    double offset = tabCenter - (screenWidth / 2);

    // Clamp offset to valid scroll range
    final maxScroll = categoryScrollController.position.maxScrollExtent;
    offset = offset.clamp(0, maxScroll);

    categoryScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  final List<Product> allProducts = [
    Product(
      name: 'Animals',
      sellingPrice: 999,
      category: Category(name: 'beginner'),
      icon: Icons.pets,
      progress: 0.75,
    ),
    Product(
      name: 'Appearance',
      sellingPrice: 29,
      category: Category(name: 'beginner'),
      icon: Icons.face,
      progress: 0.50,
    ),
    Product(
      name: 'Culture',
      sellingPrice: 15,
      category: Category(name: 'beginner'),
      icon: Icons.museum,
      progress: 0.25,
    ),
    Product(
      name: 'Buildings',
      sellingPrice: 499,
      category: Category(name: 'beginner'),
      icon: Icons.apartment,
      progress: 0.90,
    ),
    Product(
      name: 'Nature',
      sellingPrice: 79,
      category: Category(name: 'beginner'),
      icon: Icons.nature,
      progress: 0,
    ),
    Product(
      name: 'Sports',
      sellingPrice: 299,
      category: Category(name: 'beginner'),
      icon: Icons.sports,
      progress: 0,
    ),
    Product(
      name: 'Food',
      sellingPrice: 199,
      category: Category(name: 'beginner'),
      icon: Icons.fastfood,
      progress: 0,
    ),
    Product(
      name: 'Clothes',
      sellingPrice: 49,
      category: Category(name: 'beginner'),
      icon: Icons.checkroom,
      progress: 0,
    ),
    Product(
      name: 'Travel',
      sellingPrice: 89,
      category: Category(name: 'preintermediate'),
      icon: Icons.travel_explore,
      progress: 0.30,
    ),
    Product(
      name: 'Technology',
      sellingPrice: 599,
      category: Category(name: 'preintermediate'),
      icon: Icons.computer,
      progress: 0.85,
    ),
    Product(
      name: 'Health',
      sellingPrice: 39,
      category: Category(name: 'preintermediate'),
      icon: Icons.health_and_safety,
      progress: 0.55,
    ),
    Product(
      name: 'Education',
      sellingPrice: 69,
      category: Category(name: 'preintermediate'),
      icon: Icons.school,
      progress: 0.45,
    ),
  ];
}

class Category {
  final String name;

  Category({required this.name});
}

class Product {
  final String name;
  final double sellingPrice;
  Category? category;
  IconData? icon;
  double? progress;

  Product({
    required this.name,
    required this.sellingPrice,
    this.category,
    this.icon,
    this.progress,
  });
}
