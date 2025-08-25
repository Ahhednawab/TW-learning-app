import 'package:cloud_firestore/cloud_firestore.dart';

class ExampleSentence {
  final String traditional;
  final String pinyin;
  final String english;

  ExampleSentence({
    required this.traditional,
    required this.pinyin,
    required this.english,
  });

  factory ExampleSentence.fromMap(Map<String, dynamic> map) {
    return ExampleSentence(
      traditional: map['traditional'] ?? '',
      pinyin: map['pinyin'] ?? '',
      english: map['english'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'traditional': traditional,
      'pinyin': pinyin,
      'english': english,
    };
  }
}

class WordModel {
  final String wordId;
  final String categoryId;
  final String levelId;
  final String traditional;
  final String simplified;
  final String pinyin;
  final String english;
  final String partOfSpeech;
  final ExampleSentence exampleSentence;
  final String audioUrl;
  final String imageUrl;
  final int difficulty;
  final List<String> tags;
  final bool isActive;
  final DateTime createdAt;

  WordModel({
    required this.wordId,
    required this.categoryId,
    required this.levelId,
    required this.traditional,
    required this.simplified,
    required this.pinyin,
    required this.english,
    required this.partOfSpeech,
    required this.exampleSentence,
    required this.audioUrl,
    required this.imageUrl,
    required this.difficulty,
    required this.tags,
    required this.isActive,
    required this.createdAt,
  });

  factory WordModel.fromMap(String wordId, Map<String, dynamic> map) {
    return WordModel(
      wordId: wordId,
      categoryId: map['categoryId'] ?? '',
      levelId: map['levelId'] ?? '',
      traditional: map['traditional'] ?? '',
      simplified: map['simplified'] ?? '',
      pinyin: map['pinyin'] ?? '',
      english: map['english'] ?? '',
      partOfSpeech: map['partOfSpeech'] ?? '',
      exampleSentence: ExampleSentence.fromMap(map['exampleSentence'] ?? {}),
      audioUrl: map['audioUrl'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      difficulty: map['difficulty'] ?? 1,
      tags: List<String>.from(map['tags'] ?? []),
      isActive: map['isActive'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'levelId': levelId,
      'traditional': traditional,
      'simplified': simplified,
      'pinyin': pinyin,
      'english': english,
      'partOfSpeech': partOfSpeech,
      'exampleSentence': exampleSentence.toMap(),
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'difficulty': difficulty,
      'tags': tags,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
