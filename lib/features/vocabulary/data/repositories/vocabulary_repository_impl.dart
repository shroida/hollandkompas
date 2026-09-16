import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/vocabulary_stats.dart';
import '../../domain/entities/vocabulary_word.dart';
import '../../domain/repositories/vocabulary_repository.dart';
import '../datasource/vocabulary_local_cache.dart';
import '../datasource/vocabulary_remote_datasource.dart';
import '../models/vocabulary_word_model.dart';

class VocabularyRepositoryImpl implements VocabularyRepository {
  VocabularyRepositoryImpl(this._remote, this._cache, this._client);

  final VocabularyRemoteDataSource _remote;
  final VocabularyLocalCache _cache;
  final SupabaseClient _client;

  String? get _userId => _client.auth.currentUser?.id;

  /// Attaches the signed-in user's favorite flag and progress status to
  /// each word. Signed-out users just get the plain word list back.
  Future<List<VocabularyWord>> _attachUserState(
    List<VocabularyWordModel> models,
  ) async {
    final userId = _userId;
    if (userId == null || models.isEmpty) {
      return models.map((m) => m.toEntity()).toList();
    }

    final favoriteIds = await _remote.getFavoriteWordIds(userId);
    final progressMap = await _remote.getProgressMap(userId);

    return models.map((model) {
      final merged = model.copyWith(
        isFavorite: favoriteIds.contains(model.id),
        progressStatus: progressMap[model.id] ?? model.progressStatus,
      );
      return merged.toEntity();
    }).toList();
  }

  @override
  Future<List<VocabularyWord>> getWords({
    VocabularyLevel? level,
    VocabularyCategory? category,
  }) async {
    // Only the unfiltered "browse everything" call is cached — it's the
    // one the home screen opens with, and the one worth having offline.
    if (level == null && category == null) {
      try {
        final models = await _remote.getWords();
        unawaited(_cache.saveWords(models));
        return _attachUserState(models);
      } catch (error) {
        final cached = await _cache.loadWords();
        if (cached.isNotEmpty) {
          return _attachUserState(cached);
        }
        rethrow;
      }
    }

    final models = await _remote.getWords(
      level: level?.name,
      category: category?.dbValue,
    );
    return _attachUserState(models);
  }

  @override
  Future<List<VocabularyWord>> searchWords(String query) async {
    final models = await _remote.searchWords(query);
    return _attachUserState(models);
  }

  @override
  Future<VocabularyWord> getWordById(String id) async {
    final model = await _remote.getWordById(id);
    final entities = await _attachUserState([model]);
    return entities.first;
  }

  @override
  Future<VocabularyWord> getDailyWord() async {
    final model = await _remote.getDailyWord();
    final entities = await _attachUserState([model]);
    return entities.first;
  }

  @override
  Future<List<VocabularyWord>> getFavoriteWords() async {
    final userId = _userId;
    if (userId == null) return [];

    final ids = await _remote.getFavoriteWordIds(userId);
    if (ids.isEmpty) return [];

    // Simplest correct approach for a word-bank-sized table: fetch the
    // full list and filter in Dart. Swap for an `.inFilter('id', ids)`
    // query once the table grows into the thousands of rows.
    final all = await _remote.getWords();
    final favoriteModels = all.where((m) => ids.contains(m.id)).toList();
    return _attachUserState(favoriteModels);
  }

  @override
  Future<void> setFavorite(String wordId, bool isFavorite) async {
    final userId = _userId;
    if (userId == null) {
      throw StateError('Must be signed in to save favorite words.');
    }
    if (isFavorite) {
      await _remote.addFavorite(userId, wordId);
    } else {
      await _remote.removeFavorite(userId, wordId);
    }
  }

  @override
  Future<void> updateProgress(
    String wordId,
    VocabularyProgressStatus status,
  ) async {
    final userId = _userId;
    if (userId == null) {
      throw StateError('Must be signed in to track vocabulary progress.');
    }
    await _remote.upsertProgress(userId, wordId, status.dbValue);
  }

  @override
  Future<VocabularyStats> getProgressStats() async {
    final all = await _remote.getWords();
    final userId = _userId;
    if (userId == null) {
      return VocabularyStats(
        totalWords: all.length,
        masteredWords: 0,
        learningWords: 0,
        newWords: all.length,
      );
    }

    final progressMap = await _remote.getProgressMap(userId);
    var mastered = 0;
    var learning = 0;
    for (final status in progressMap.values) {
      if (status == 'mastered') mastered++;
      if (status == 'learning') learning++;
    }
    final known = mastered + learning;
    return VocabularyStats(
      totalWords: all.length,
      masteredWords: mastered,
      learningWords: learning,
      newWords: all.length - known,
    );
  }
}
