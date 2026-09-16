import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/vocabulary_word.dart';
import '../../domain/usecases/get_daily_word_usecase.dart';
import '../../domain/usecases/get_vocabulary_words_usecase.dart';
import '../../domain/usecases/get_word_by_id_usecase.dart';
import '../../domain/usecases/search_vocabulary_usecase.dart';
import 'vocabulary_repository_provider.dart';

part 'vocabulary_list_providers.g.dart';

@riverpod
class SelectedVocabularyLevel extends _$SelectedVocabularyLevel {
  @override
  String? build() => null;

  void set(String? level) {
    state = level;
  }
}

@riverpod
class SelectedVocabularyCategory extends _$SelectedVocabularyCategory {
  @override
  String? build() => null;

  void set(String? category) {
    state = category;
  }
}

@riverpod
Future<List<VocabularyWord>> vocabularyWords(Ref ref) {
  final level = ref.watch(selectedVocabularyLevelProvider);
  final category = ref.watch(selectedVocabularyCategoryProvider);

  final usecase = GetVocabularyWordsUseCase(
    ref.watch(vocabularyRepositoryProvider),
  );

  return usecase(level: level, category: category);
}

@riverpod
class VocabularySearchQuery extends _$VocabularySearchQuery {
  @override
  String build() => '';

  void set(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

@riverpod
Future<List<VocabularyWord>> vocabularySearchResults(Ref ref) {
  final query = ref.watch(vocabularySearchQueryProvider);

  if (query.trim().isEmpty) {
    return Future.value(const []);
  }

  final usecase = SearchVocabularyUseCase(
    ref.watch(vocabularyRepositoryProvider),
  );

  return usecase(query.trim());
}

@riverpod
Future<VocabularyWord> dailyVocabularyWord(Ref ref) {
  final usecase = GetDailyWordUseCase(ref.watch(vocabularyRepositoryProvider));

  return usecase();
}

@riverpod
Future<VocabularyWord> vocabularyWordById(Ref ref, String id) {
  final usecase = GetWordByIdUseCase(ref.watch(vocabularyRepositoryProvider));

  return usecase(id);
}
