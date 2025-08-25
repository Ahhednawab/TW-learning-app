import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteModel {
  final String wordId;
  final DateTime addedAt;
  final String categoryId;
  final String levelId;

  FavoriteModel({
    required this.wordId,
    required this.addedAt,
    required this.categoryId,
    required this.levelId,
  });

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      wordId: map['wordId'] ?? '',
      addedAt: (map['addedAt'] as Timestamp).toDate(),
      categoryId: map['categoryId'] ?? '',
      levelId: map['levelId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'wordId': wordId,
      'addedAt': Timestamp.fromDate(addedAt),
      'categoryId': categoryId,
      'levelId': levelId,
    };
  }
}
