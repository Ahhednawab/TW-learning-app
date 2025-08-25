import 'package:cloud_firestore/cloud_firestore.dart';

class DailyWordModel {
  final String wordId;
  final String date;
  final DateTime createdAt;

  DailyWordModel({
    required this.wordId,
    required this.date,
    required this.createdAt,
  });

  factory DailyWordModel.fromMap(Map<String, dynamic> map) {
    return DailyWordModel(
      wordId: map['wordId'] ?? '',
      date: map['date'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'wordId': wordId,
      'date': date,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
