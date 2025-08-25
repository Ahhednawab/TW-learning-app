import 'package:cloud_firestore/cloud_firestore.dart';

class LevelModel {
  final String levelId;
  final String name;
  final int order;
  final String description;
  final bool isActive;
  final int totalCategories;
  final DateTime createdAt;

  LevelModel({
    required this.levelId,
    required this.name,
    required this.order,
    required this.description,
    required this.isActive,
    required this.totalCategories,
    required this.createdAt,
  });

  factory LevelModel.fromMap(String levelId, Map<String, dynamic> map) {
    return LevelModel(
      levelId: levelId,
      name: map['name'] ?? '',
      order: map['order'] ?? 0,
      description: map['description'] ?? '',
      isActive: map['isActive'] ?? true,
      totalCategories: map['totalCategories'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'order': order,
      'description': description,
      'isActive': isActive,
      'totalCategories': totalCategories,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
