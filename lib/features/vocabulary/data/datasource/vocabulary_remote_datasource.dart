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

  Future<Map<String, String>> getProgressMap(String userId);

  Future<void> upsertProgress(String userId, String wordId, String status);
}

class VocabularyRemoteDataSourceImpl implements VocabularyRemoteDataSource {
  VocabularyRemoteDataSourceImpl(this._client);

  final SupabaseClient _client;

  static const _wordsTable = 'vocabularies';
  static const _favoritesTable = 'user_favorite_words';
  static const _progressTable = 'user_vocabulary_progress';

  /*
   * vocabularies does not contain `level`.
   *
   * Current relation:
   *
   * vocabularies.lesson_id
   *       ↓
   * lessons.course_id
   *       ↓
   * courses.level
   *
   * This nested select assumes those foreign keys
   * exist in Supabase.
   */
  static const _wordSelect = '''
    id,
    lesson_id,
    word,
    translation_en,
    translation_ar,
    category,
    created_at,
    lessons!inner(
      course_id,
      courses!inner(
        level
      )
    )
  ''';

  VocabularyWordModel _mapRow(Map<String, dynamic> row) {
    final lesson = row['lessons'] as Map<String, dynamic>?;

    final course = lesson?['courses'] as Map<String, dynamic>?;

    final level = course?['level']?.toString() ?? '';

    return VocabularyWordModel.fromJson({...row, 'level': level});
  }

  @override
  Future<List<VocabularyWordModel>> getWords({
    String? level,
    String? category,
  }) async {
    var query = _client.from(_wordsTable).select(_wordSelect);

    if (level != null) {
      query = query.eq('lessons.courses.level', level);
    }

    if (category != null) {
      query = query.eq('category', category);
    }

    final rows = await query.order('word', ascending: true);

    return (rows as List)
        .map((row) => _mapRow(Map<String, dynamic>.from(row)))
        .toList();
  }

  @override
  Future<List<VocabularyWordModel>> searchWords(String query) async {
    final safeQuery = query.replaceAll(',', ' ').trim();

    if (safeQuery.isEmpty) {
      return [];
    }

    final rows = await _client
        .from(_wordsTable)
        .select(_wordSelect)
        .or(
          'word.ilike.%$safeQuery%,'
          'translation_ar.ilike.%$safeQuery%,'
          'translation_en.ilike.%$safeQuery%',
        )
        .order('word', ascending: true);

    return (rows as List)
        .map((row) => _mapRow(Map<String, dynamic>.from(row)))
        .toList();
  }

  @override
  Future<VocabularyWordModel> getWordById(String id) async {
    final row = await _client
        .from(_wordsTable)
        .select(_wordSelect)
        .eq('id', id)
        .single();

    return _mapRow(Map<String, dynamic>.from(row));
  }

  @override
  Future<VocabularyWordModel> getDailyWord() async {
    final rows = await _client
        .from(_wordsTable)
        .select(_wordSelect)
        .order('word', ascending: true);

    if (rows.isEmpty) {
      throw StateError('No vocabulary words found yet.');
    }

    final list = (rows as List)
        .map((row) => _mapRow(Map<String, dynamic>.from(row)))
        .toList();

    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;

    final index = dayOfYear % list.length;

    return list[index];
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
      for (final row in rows as List)
        row['word_id'] as String: row['status'] as String,
    };
  }

  @override
  Future<void> upsertProgress(
    String userId,
    String wordId,
    String status,
  ) async {
    await _client.from(_progressTable).upsert({
      'user_id': userId,
      'word_id': wordId,
      'status': status,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }
}
