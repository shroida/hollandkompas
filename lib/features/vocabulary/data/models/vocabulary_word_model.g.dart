// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocabulary_word_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VocabularyWordModel _$VocabularyWordModelFromJson(
  Map<String, dynamic> json,
) => _VocabularyWordModel(
  id: json['id'] as String,
  dutchWord: json['dutch_word'] as String,
  arabicMeaning: json['arabic_meaning'] as String,
  level: json['level'] as String,
  category: json['category'] as String,
  germanMeaning: json['german_meaning'] as String?,
  pronunciation: json['pronunciation'] as String?,
  exampleSentenceDutch: json['example_sentence_nl'] as String?,
  exampleSentenceArabic: json['example_sentence_ar'] as String?,
  synonyms:
      (json['synonyms'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  antonyms:
      (json['antonyms'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$VocabularyWordModelToJson(
  _VocabularyWordModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'dutch_word': instance.dutchWord,
  'arabic_meaning': instance.arabicMeaning,
  'level': instance.level,
  'category': instance.category,
  'german_meaning': instance.germanMeaning,
  'pronunciation': instance.pronunciation,
  'example_sentence_nl': instance.exampleSentenceDutch,
  'example_sentence_ar': instance.exampleSentenceArabic,
  'synonyms': instance.synonyms,
  'antonyms': instance.antonyms,
};
