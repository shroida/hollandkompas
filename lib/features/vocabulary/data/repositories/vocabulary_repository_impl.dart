import 'dart:async';

import 'package:flutter/foundation.dart';
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

  Future<List<VocabularyWord>> _attachUserState(
    List<VocabularyWordModel> models,
  ) async {
    if (models.isEmpty) {
      return const [];
    }

    final userId = _userId;

    // No signed-in user => return plain vocabulary.
    if (userId == null) {
      return models.map((model) => model.toEntity()).toList();
    }

    Set<String> favoriteIds = <String>{};
    Map<String, String> progressMap = <String, String>{};

    // Favorites are optional. A missing table must NOT break
    // the vocabulary screen.
    try {
      favoriteIds = await _remote.getFavoriteWordIds(userId);
    } catch (error) {
      _debug(
        'Could not load favorites. '
        'Continuing without favorites: $error',
      );
    }

    // Progress is optional as well.
    try {
      progressMap = await _remote.getProgressMap(userId);
    } catch (error) {
      _debug(
        'Could not load vocabulary progress. '
        'Continuing without progress: $error',
      );
    }

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
    String? level,
    String? category,
  }) async {
    _debug('getWords | level=$level | category=$category');

    if (level == null && category == null) {
      try {
        final models = await _remote.getWords();

        _debug('Remote returned ${models.length} vocabulary models');

        unawaited(_cache.saveWords(models));

        return _attachUserState(models);
      } catch (error) {
        _debug('Remote vocabulary load failed: $error');

        final cached = await _cache.loadWords();

        if (cached.isNotEmpty) {
          _debug('Using ${cached.length} cached vocabulary models');

          return _attachUserState(cached);
        }

        rethrow;
      }
    }

    final models = await _remote.getWords(level: level, category: category);

    _debug('Filtered remote returned ${models.length} models');

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

    if (userId == null) {
      return const [];
    }

    try {
      final ids = await _remote.getFavoriteWordIds(userId);

      if (ids.isEmpty) {
        return const [];
      }

      final all = await _remote.getWords();

      final favoriteModels = all
          .where((model) => ids.contains(model.id))
          .toList();

      return _attachUserState(favoriteModels);
    } catch (error) {
      _debug('getFavoriteWords failed: $error');

      return const [];
    }
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

    Map<String, String> progressMap = <String, String>{};

    try {
      progressMap = await _remote.getProgressMap(userId);
    } catch (error) {
      _debug('Could not load progress stats: $error');
    }

    var mastered = 0;
    var learning = 0;

    for (final status in progressMap.values) {
      if (status == 'mastered') {
        mastered++;
      } else if (status == 'learning') {
        learning++;
      }
    }

    final known = mastered + learning;

    return VocabularyStats(
      totalWords: all.length,
      masteredWords: mastered,
      learningWords: learning,
      newWords: all.length - known,
    );
  }

  void _debug(String message) {
    if (kDebugMode) {
      debugPrint('[VOCAB-REPOSITORY] $message');
    }
  }
}
