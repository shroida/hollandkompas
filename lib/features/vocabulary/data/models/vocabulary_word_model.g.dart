// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocabulary_word_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VocabularyWordModel _$VocabularyWordModelFromJson(Map<String, dynamic> json) =>
    _VocabularyWordModel(
      id: json['id'] as String,
      dutchWord: json['word'] as String,
      arabicMeaning: json['translation_ar'] as String,
      englishMeaning: json['translation_en'] as String?,
      level: json['level'] as String,
      category: json['category'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$VocabularyWordModelToJson(
  _VocabularyWordModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'word': instance.dutchWord,
  'translation_ar': instance.arabicMeaning,
  'translation_en': instance.englishMeaning,
  'level': instance.level,
  'category': instance.category,
  'created_at': instance.createdAt?.toIso8601String(),
};
