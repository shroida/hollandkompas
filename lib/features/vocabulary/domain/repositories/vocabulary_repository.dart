import '../entities/vocabulary_stats.dart';
import '../entities/vocabulary_word.dart';

/// Contract the data layer must fulfil. Nothing in this file may import
/// `supabase_flutter` — that dependency stays in `data/`.
abstract class VocabularyRepository {
  /// All words, optionally filtered by [level] and/or [category].
  Future<List<VocabularyWord>> getWords({
    VocabularyLevel? level,
    VocabularyCategory? category,
  });

  /// Matches [query] against the Dutch word or the Arabic meaning.
  Future<List<VocabularyWord>> searchWords(String query);

  Future<VocabularyWord> getWordById(String id);

  /// Same word for every user on a given calendar day, rotating daily.
  Future<VocabularyWord> getDailyWord();

  /// Words the signed-in user has saved. Empty if signed out.
  Future<List<VocabularyWord>> getFavoriteWords();

  Future<void> setFavorite(String wordId, bool isFavorite);

  Future<void> updateProgress(String wordId, VocabularyProgressStatus status);

  /// Signed-in user's mastered/learning/new counts across the word bank.
  Future<VocabularyStats> getProgressStats();
}
