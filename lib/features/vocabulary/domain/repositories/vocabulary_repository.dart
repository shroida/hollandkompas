import '../entities/vocabulary_stats.dart';
import '../entities/vocabulary_word.dart';

abstract class VocabularyRepository {
  Future<List<VocabularyWord>> getWords({String? level, String? category});
  Future<List<VocabularyWord>> searchWords(String query);

  Future<VocabularyWord> getWordById(String id);

  Future<VocabularyWord> getDailyWord();

  Future<List<VocabularyWord>> getFavoriteWords();

  Future<void> setFavorite(String wordId, bool isFavorite);

  Future<void> updateProgress(String wordId, VocabularyProgressStatus status);

  Future<VocabularyStats> getProgressStats();
}
