import '../../domain/entities/flashcard.dart';

class FlashcardModel {
  const FlashcardModel({
    required this.id,
    required this.dutchWord,
    required this.arabicMeaning,
    this.englishMeaning,
    required this.level,
    required this.category,
    this.createdAt,
    this.isFavorite = false,
    this.status = 'new',
    this.reviewCount = 0,
    this.intervalDays = 0,
    this.nextReviewAt,
    this.lastReviewedAt,
    this.forgetCount = 0,
  });

  final String id;
  final String dutchWord;
  final String arabicMeaning;
  final String? englishMeaning;
  final String level;
  final String category;
  final DateTime? createdAt;
  final bool isFavorite;
  final String status;
  final int reviewCount;
  final int intervalDays;
  final DateTime? nextReviewAt;
  final DateTime? lastReviewedAt;
  final int forgetCount;

  factory FlashcardModel.fromMap(Map<String, dynamic> map) {
    return FlashcardModel(
      id: map['id']?.toString() ?? '',
      dutchWord: map['word']?.toString() ?? '',
      arabicMeaning: map['translation_ar']?.toString() ?? '',
      englishMeaning: map['translation_en']?.toString(),
      level: map['level']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      createdAt: map['created_at'] == null
          ? null
          : DateTime.tryParse(map['created_at'].toString()),
      isFavorite: map['is_favorite'] == true,
      status: map['status']?.toString() ?? 'new',
      reviewCount: _toInt(map['review_count']),
      intervalDays: _toInt(map['interval_days']),
      nextReviewAt: map['next_review_at'] == null
          ? null
          : DateTime.tryParse(map['next_review_at'].toString()),
      lastReviewedAt: map['last_reviewed_at'] == null
          ? null
          : DateTime.tryParse(map['last_reviewed_at'].toString()),
      forgetCount: _toInt(map['forget_count']),
    );
  }

  Flashcard toEntity() {
    return Flashcard(
      id: id,
      dutchWord: dutchWord,
      arabicMeaning: arabicMeaning,
      englishMeaning: englishMeaning,
      level: level,
      category: category,
      createdAt: createdAt,
      isFavorite: isFavorite,
      status: status,
      reviewCount: reviewCount,
      intervalDays: intervalDays,
      nextReviewAt: nextReviewAt,
      lastReviewedAt: lastReviewedAt,
      forgetCount: forgetCount,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
