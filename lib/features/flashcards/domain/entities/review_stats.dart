import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_stats.freezed.dart';

@freezed
abstract class ReviewStats with _$ReviewStats {
  const factory ReviewStats({
    required int total,
    required int dueToday,
    required int weakWords,
    required int mastered,
  }) = _ReviewStats;
}
