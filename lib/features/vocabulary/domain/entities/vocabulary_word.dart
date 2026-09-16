import 'package:freezed_annotation/freezed_annotation.dart';

part 'vocabulary_word.freezed.dart';

enum VocabularyLevel { a1, a2, b1, b2 }

enum VocabularyProgressStatus { newWord, learning, mastered }

@freezed
abstract class VocabularyWord with _$VocabularyWord {
  const factory VocabularyWord({
    required String id,
    required String dutchWord,
    required String arabicMeaning,
    String? englishMeaning,
    required String level,
    required String category,
    DateTime? createdAt,

    @Default(false) bool isFavorite,

    @Default(VocabularyProgressStatus.newWord)
    VocabularyProgressStatus progressStatus,
  }) = _VocabularyWord;
}
