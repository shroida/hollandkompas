import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/vocabulary_stats.dart';
import '../../domain/entities/vocabulary_word.dart';
import '../../domain/usecases/get_favorite_words_usecase.dart';
import '../../domain/usecases/get_vocabulary_stats_usecase.dart';
import '../../domain/usecases/toggle_favorite_word_usecase.dart';
import '../../domain/usecases/update_vocabulary_progress_usecase.dart';
import 'vocabulary_list_providers.dart';
import 'vocabulary_repository_provider.dart';

part 'vocabulary_user_providers.g.dart';

@riverpod
Future<List<VocabularyWord>> favoriteVocabularyWords(Ref ref) {
  final usecase = GetFavoriteWordsUseCase(
    ref.watch(vocabularyRepositoryProvider),
  );

  return usecase();
}

@riverpod
Future<VocabularyStats> vocabularyProgressStats(Ref ref) {
  final usecase = GetVocabularyStatsUseCase(
    ref.watch(vocabularyRepositoryProvider),
  );

  return usecase();
}

@riverpod
class VocabularyActions extends _$VocabularyActions {
  @override
  void build() {}

  Future<void> toggleFavorite(String wordId, bool isFavorite) async {
    try {
      final usecase = ToggleFavoriteWordUseCase(
        ref.read(vocabularyRepositoryProvider),
      );

      await usecase(wordId, isFavorite);

      if (!ref.mounted) return;

      ref.invalidate(favoriteVocabularyWordsProvider);
      ref.invalidate(vocabularyWordsProvider);
      ref.invalidate(vocabularyWordByIdProvider(wordId));
    } catch (error, stackTrace) {
      if (!ref.mounted) return;

      debugPrint('[VOCAB-ACTION] toggleFavorite ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<void> updateProgress(
    String wordId,
    VocabularyProgressStatus status,
  ) async {
    debugPrint(
      '[VOCAB-PROGRESS] START '
      'wordId=$wordId '
      'status=$status',
    );

    try {
      final usecase = UpdateVocabularyProgressUseCase(
        ref.read(vocabularyRepositoryProvider),
      );

      await usecase(wordId, status);

      if (!ref.mounted) return;

      debugPrint(
        '[VOCAB-PROGRESS] SUCCESS '
        'wordId=$wordId '
        'status=$status',
      );

      ref.invalidate(vocabularyProgressStatsProvider);
      ref.invalidate(vocabularyWordsProvider);
      ref.invalidate(vocabularyWordByIdProvider(wordId));
    } catch (error, stackTrace) {
      if (!ref.mounted) return;

      debugPrint(
        '[VOCAB-PROGRESS] ERROR '
        'wordId=$wordId '
        'status=$status '
        'error=$error',
      );

      debugPrintStack(stackTrace: stackTrace);

      rethrow;
    }
  }
}
