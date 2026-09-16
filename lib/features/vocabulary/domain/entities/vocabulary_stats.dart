import 'package:freezed_annotation/freezed_annotation.dart';

part 'vocabulary_stats.freezed.dart';

/// Aggregate counts behind the "Vocabulary Progress" (نسبة الحفظ) screen.
@freezed
abstract class VocabularyStats with _$VocabularyStats {
  const factory VocabularyStats({
    required int totalWords,
    required int masteredWords,
    required int learningWords,
    required int newWords,
  }) = _VocabularyStats;

  const VocabularyStats._();

  /// 0–100. Safe when [totalWords] is 0 (no words loaded yet).
  double get masteredPercentage =>
      totalWords == 0 ? 0 : (masteredWords / totalWords) * 100;
}
