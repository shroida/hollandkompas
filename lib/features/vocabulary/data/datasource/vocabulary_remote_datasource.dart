import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/vocabulary_word_model.dart';

abstract class VocabularyRemoteDataSource {
  Future<List<VocabularyWordModel>> getWords({String? level, String? category});

  Future<List<VocabularyWordModel>> searchWords(String query);

  Future<VocabularyWordModel> getWordById(String id);

  Future<VocabularyWordModel> getDailyWord();

  Future<List<String>> getFavoriteWordIds(String userId);

  Future<void> addFavorite(String userId, String wordId);

  Future<void> removeFavorite(String userId, String wordId);

  /// wordId -> raw status string ('new' | 'learning' | 'mastered').
  Future<Map<String, String>> getProgressMap(String userId);

  Future<void> upsertProgress(String userId, String wordId, String status);
}

class VocabularyRemoteDataSourceImpl implements VocabularyRemoteDataSource {
  VocabularyRemoteDataSourceImpl(this._client);

  final SupabaseClient _client;

  static const _wordsTable = 'vocabularies';
  static const _favoritesTable = 'user_favorite_words';
  static const _progressTable = 'user_vocabulary_progress';

  @override
  Future<List<VocabularyWordModel>> getWords({
    String? level,
    String? category,
  }) async {
    var query = _client.from(_wordsTable).select();
    if (level != null) {
      query = query.eq('level', level);
    }
    if (category != null) {
      query = query.eq('category', category);
    }
    final rows = await query.order('dutch_word', ascending: true);
    return (rows as List)
        .map((row) => VocabularyWordModel.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<VocabularyWordModel>> searchWords(String query) async {
    // Commas would break the .or() filter string below, so strip them.
    final safeQuery = query.replaceAll(',', ' ');
    final rows = await _client
        .from(_wordsTable)
        .select()
        .or('dutch_word.ilike.%$safeQuery%,arabic_meaning.ilike.%$safeQuery%')
        .order('dutch_word', ascending: true);
    return (rows as List)
        .map((row) => VocabularyWordModel.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<VocabularyWordModel> getWordById(String id) async {
    final row = await _client.from(_wordsTable).select().eq('id', id).single();
    return VocabularyWordModel.fromJson(row);
  }

  @override
  Future<VocabularyWordModel> getDailyWord() async {
    // No dedicated "daily word" table: the word of the day is derived
    // deterministically from the current date, so it's the same for
    // every user and rotates automatically at midnight with no cron
    // job or extra writes needed.
    final rows = await _client.from(_wordsTable).select().order('dutch_word');
    final list = (rows as List).cast<Map<String, dynamic>>();
    if (list.isEmpty) {
      throw StateError('No vocabulary words found yet.');
    }
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final index = dayOfYear % list.length;
    return VocabularyWordModel.fromJson(list[index]);
  }

  @override
  Future<List<String>> getFavoriteWordIds(String userId) async {
    final rows = await _client
        .from(_favoritesTable)
        .select('word_id')
        .eq('user_id', userId);
    return (rows as List).map((row) => row['word_id'] as String).toList();
  }

  @override
  Future<void> addFavorite(String userId, String wordId) async {
    await _client.from(_favoritesTable).upsert({
      'user_id': userId,
      'word_id': wordId,
    });
  }

  @override
  Future<void> removeFavorite(String userId, String wordId) async {
    await _client
        .from(_favoritesTable)
        .delete()
        .eq('user_id', userId)
        .eq('word_id', wordId);
  }

  @override
  Future<Map<String, String>> getProgressMap(String userId) async {
    final rows = await _client
        .from(_progressTable)
        .select('word_id, status')
        .eq('user_id', userId);
    return {
      for (final row in (rows as List)) row['word_id'] as String: row['status'] as String,
    };
  }

  @override
  Future<void> upsertProgress(String userId, String wordId, String status) async {
    await _client.from(_progressTable).upsert({
      'user_id': userId,
      'word_id': wordId,
      'status': status,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }
}
