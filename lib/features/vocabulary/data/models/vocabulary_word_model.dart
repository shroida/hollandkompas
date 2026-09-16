import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/vocabulary_word.dart';

part 'vocabulary_word_model.freezed.dart';
part 'vocabulary_word_model.g.dart';

@freezed
abstract class VocabularyWordModel with _$VocabularyWordModel {
  const factory VocabularyWordModel({
    required String id,

    @JsonKey(name: 'word') required String dutchWord,

    @JsonKey(name: 'translation_ar') required String arabicMeaning,

    @JsonKey(name: 'translation_en') String? englishMeaning,

    required String level,

    required String category,

    @JsonKey(name: 'created_at') DateTime? createdAt,

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
      englishMeaning: englishMeaning,
      level: level,
      category: category,
      createdAt: createdAt,
      isFavorite: isFavorite,
      progressStatus: VocabularyProgressStatusDb.fromDb(progressStatus),
    );
  }
}

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
