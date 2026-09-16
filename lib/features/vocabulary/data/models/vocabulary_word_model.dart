import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/vocabulary_word.dart';

part 'vocabulary_word_model.freezed.dart';
part 'vocabulary_word_model.g.dart';

/// Maps [VocabularyCategory] <-> the snake_case text stored in
/// `vocabularies.category`. Kept in the data layer on purpose — the
/// domain layer shouldn't know or care how the DB spells things.
extension VocabularyCategoryDb on VocabularyCategory {
  static VocabularyCategory fromDb(String value) {
    switch (value) {
      case 'greetings':
        return VocabularyCategory.greetings;
      case 'numbers':
        return VocabularyCategory.numbers;
      case 'family':
        return VocabularyCategory.family;
      case 'food':
        return VocabularyCategory.food;
      case 'health':
        return VocabularyCategory.health;
      case 'travel':
        return VocabularyCategory.travel;
      case 'work':
        return VocabularyCategory.work;
      case 'society':
        return VocabularyCategory.society;
      case 'call_center':
        return VocabularyCategory.callCenter;
      case 'daily_life':
      default:
        return VocabularyCategory.dailyLife;
    }
  }

  String get dbValue {
    switch (this) {
      case VocabularyCategory.greetings:
        return 'greetings';
      case VocabularyCategory.numbers:
        return 'numbers';
      case VocabularyCategory.family:
        return 'family';
      case VocabularyCategory.food:
        return 'food';
      case VocabularyCategory.dailyLife:
        return 'daily_life';
      case VocabularyCategory.health:
        return 'health';
      case VocabularyCategory.travel:
        return 'travel';
      case VocabularyCategory.work:
        return 'work';
      case VocabularyCategory.society:
        return 'society';
      case VocabularyCategory.callCenter:
        return 'call_center';
    }
  }
}

/// Maps [VocabularyProgressStatus] <-> `user_vocabulary_progress.status`.
extension VocabularyProgressStatusDb on VocabularyProgressStatus {
  static VocabularyProgressStatus fromDb(String value) {
    switch (value) {
      case 'learning':
        return VocabularyProgressStatus.learning;
      case 'mastered':
        return VocabularyProgressStatus.mastered;
      case 'new':
      default:
        return VocabularyProgressStatus.newWord;
    }
  }

  String get dbValue {
    switch (this) {
      case VocabularyProgressStatus.newWord:
        return 'new';
      case VocabularyProgressStatus.learning:
        return 'learning';
      case VocabularyProgressStatus.mastered:
        return 'mastered';
    }
  }
}

@freezed
abstract class VocabularyWordModel with _$VocabularyWordModel {
  const factory VocabularyWordModel({
    required String id,
    @JsonKey(name: 'dutch_word') required String dutchWord,
    @JsonKey(name: 'arabic_meaning') required String arabicMeaning,
    // Raw DB text ('a1'..'b2' / snake_case category) — converted to the
    // domain enums in [toEntity], not here.
    required String level,
    required String category,
    @JsonKey(name: 'german_meaning') String? germanMeaning,
    String? pronunciation,
    @JsonKey(name: 'example_sentence_nl') String? exampleSentenceDutch,
    @JsonKey(name: 'example_sentence_ar') String? exampleSentenceArabic,
    @Default(<String>[]) List<String> synonyms,
    @Default(<String>[]) List<String> antonyms,
    // Not columns on `vocabularies` — filled in by the repository after
    // joining with the user's favorites/progress rows. Never sent to
    // or read from Supabase directly on this table.
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool isFavorite,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('new')
    String progressStatus,
  }) = _VocabularyWordModel;

  const VocabularyWordModel._();

  factory VocabularyWordModel.fromJson(Map<String, dynamic> json) =>
      _$VocabularyWordModelFromJson(json);

  VocabularyWord toEntity() {
    return VocabularyWord(
      id: id,
      dutchWord: dutchWord,
      arabicMeaning: arabicMeaning,
      germanMeaning: germanMeaning,
      level: VocabularyLevel.values.byName(level),
      category: VocabularyCategoryDb.fromDb(category),
      pronunciation: pronunciation,
      exampleSentenceDutch: exampleSentenceDutch,
      exampleSentenceArabic: exampleSentenceArabic,
      synonyms: synonyms,
      antonyms: antonyms,
      isFavorite: isFavorite,
      progressStatus: VocabularyProgressStatusDb.fromDb(progressStatus),
    );
  }
}
