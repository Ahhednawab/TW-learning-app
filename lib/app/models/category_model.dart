import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String categoryId;
  final String levelId;
  final String name;
  final String nameEn;
  final String icon;
  final int order;
  final int totalWords;
  final bool isActive;
  final DateTime createdAt;

  CategoryModel({
    required this.categoryId,
    required this.levelId,
    required this.name,
    required this.nameEn,
    required this.icon,
    required this.order,
    required this.totalWords,
    required this.isActive,
    required this.createdAt,
  });

  factory CategoryModel.fromMap(String categoryId, Map<String, dynamic> map) {
    return CategoryModel(
      categoryId: categoryId,
      levelId: map['levelId'] ?? '',
      name: map['name'] ?? '',
      nameEn: map['nameEn'] ?? '',
      icon: map['icon'] ?? '',
      order: map['order'] ?? 0,
      totalWords: map['totalWords'] ?? 0,
      isActive: map['isActive'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'levelId': levelId,
      'name': name,
      'nameEn': nameEn,
      'icon': icon,
      'order': order,
      'totalWords': totalWords,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
