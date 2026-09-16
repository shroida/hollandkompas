import 'package:freezed_annotation/freezed_annotation.dart';

part 'vocabulary_word.freezed.dart';

/// CEFR level a word belongs to.
enum VocabularyLevel { a1, a2, b1, b2 }

/// Topic a word is grouped under for the "browse by topic" screen.
/// `callCenter` is its own topic (reservations / customer-service
/// Dutch) rather than a CEFR level, since call-center words span
/// several levels.
enum VocabularyCategory {
  greetings,
  numbers,
  family,
  food,
  dailyLife,
  health,
  travel,
  work,
  society,
  callCenter,
}

/// Per-user memorization status for a word (drives the Vocabulary
/// Progress screen).
enum VocabularyProgressStatus { newWord, learning, mastered }

@freezed
abstract class VocabularyWord with _$VocabularyWord {
  const factory VocabularyWord({
    required String id,
    required String dutchWord,
    required String arabicMeaning,
    required VocabularyLevel level,
    required VocabularyCategory category,
    String? germanMeaning,
    String? pronunciation,
    String? exampleSentenceDutch,
    String? exampleSentenceArabic,
    @Default(<String>[]) List<String> synonyms,
    @Default(<String>[]) List<String> antonyms,
    @Default(false) bool isFavorite,
    @Default(VocabularyProgressStatus.newWord)
    VocabularyProgressStatus progressStatus,
  }) = _VocabularyWord;
}
