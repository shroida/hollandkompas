import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/vocabulary_word.dart';
import '../../domain/usecases/get_daily_word_usecase.dart';
import '../../domain/usecases/get_vocabulary_words_usecase.dart';
import '../../domain/usecases/get_word_by_id_usecase.dart';
import '../../domain/usecases/search_vocabulary_usecase.dart';
import 'vocabulary_repository_provider.dart';

part 'vocabulary_list_providers.g.dart';

/// Selected level filter on the Vocabulary Database screen.
/// `null` = all levels.
@riverpod
class SelectedVocabularyLevel extends _$SelectedVocabularyLevel {
  @override
  VocabularyLevel? build() => null;

  void set(VocabularyLevel? level) => state = level;
}

/// Selected topic filter on the Vocabulary Database / Categories screen.
/// `null` = all categories.
@riverpod
class SelectedVocabularyCategory extends _$SelectedVocabularyCategory {
  @override
  VocabularyCategory? build() => null;

  void set(VocabularyCategory? category) => state = category;
}

/// Word list for the current filter selection above.
@riverpod
Future<List<VocabularyWord>> vocabularyWords(Ref ref) {
  final level = ref.watch(selectedVocabularyLevelProvider);
  final category = ref.watch(selectedVocabularyCategoryProvider);
  final usecase = GetVocabularyWordsUseCase(ref.watch(vocabularyRepositoryProvider));
  return usecase(level: level, category: category);
}

/// Live text typed into the Vocabulary Search screen.
@riverpod
class VocabularySearchQuery extends _$VocabularySearchQuery {
  @override
  String build() => '';

  void set(String query) => state = query;
}

@riverpod
Future<List<VocabularyWord>> vocabularySearchResults(Ref ref) {
  final query = ref.watch(vocabularySearchQueryProvider);
  if (query.trim().isEmpty) return Future.value(const []);
  final usecase = SearchVocabularyUseCase(ref.watch(vocabularyRepositoryProvider));
  return usecase(query);
}

/// Today's word of the day.
@riverpod
Future<VocabularyWord> dailyVocabularyWord(Ref ref) {
  final usecase = GetDailyWordUseCase(ref.watch(vocabularyRepositoryProvider));
  return usecase();
}

/// A single word by id, kept live so the details screen reflects
/// favorite/progress changes without a manual refresh.
@riverpod
Future<VocabularyWord> vocabularyWordById(Ref ref, String id) {
  final usecase = GetWordByIdUseCase(ref.watch(vocabularyRepositoryProvider));
  return usecase(id);
}
