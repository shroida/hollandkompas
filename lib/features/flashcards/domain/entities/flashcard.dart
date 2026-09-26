import 'package:freezed_annotation/freezed_annotation.dart';

part 'flashcard.freezed.dart';

@freezed
abstract class Flashcard with _$Flashcard {
  const factory Flashcard({
    required String id,
    required String dutchWord,
    required String arabicMeaning,
    String? englishMeaning,
    required String level,
    required String category,
    DateTime? createdAt,

    @Default(false) bool isFavorite,

    @Default('new') String status,

    @Default(0) int reviewCount,

    @Default(0) int intervalDays,

    DateTime? nextReviewAt,

    DateTime? lastReviewedAt,

    @Default(0) int forgetCount,
  }) = _Flashcard;
}
