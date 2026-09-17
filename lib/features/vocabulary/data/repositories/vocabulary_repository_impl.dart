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

  static const Duration _wordsCacheMaxAge = Duration(minutes: 30);
  static const Duration _userStateCacheMaxAge = Duration(minutes: 30);

  List<VocabularyWordModel>? _memoryWords;
  DateTime? _memoryWordsUpdatedAt;

  Future<List<VocabularyWordModel>>? _refreshWordsFuture;

  final Map<String, Future<void>> _userStateRefreshes =
      <String, Future<void>>{};

  String? get _userId => _client.auth.currentUser?.id;

  Future<List<VocabularyWordModel>> _getAllModels() async {
    _debug('CACHE CHECK');

    final memoryWords = _memoryWords;

    if (memoryWords != null && memoryWords.isNotEmpty) {
      final updatedAt = _memoryWordsUpdatedAt;

      _debug(
        'MEMORY CACHE HIT | '
        'count=${memoryWords.length} | '
        'updatedAt=$updatedAt',
      );

      if (updatedAt != null &&
          DateTime.now().difference(updatedAt).abs() <= _wordsCacheMaxAge) {
        _debug('MEMORY CACHE FRESH');

        return memoryWords;
      }

      _debug('MEMORY CACHE EXPIRED');

      unawaited(_backgroundRefresh());

      return memoryWords;
    }

    _debug('MEMORY CACHE MISS');

    final cached = await _cache.loadWords();

    _debug(
      'HIVE CACHE RESULT | '
      'count=${cached.length}',
    );

    if (cached.isNotEmpty) {
      final updatedAt = await _cache.loadWordsUpdatedAt();

      _memoryWords = cached;
      _memoryWordsUpdatedAt = updatedAt;

      _debug(
        'HIVE CACHE HIT | '
        'count=${cached.length} | '
        'updatedAt=$updatedAt',
      );

      if (updatedAt != null &&
          DateTime.now().difference(updatedAt).abs() <= _wordsCacheMaxAge) {
        _debug('HIVE CACHE FRESH');

        return cached;
      }

      _debug('HIVE CACHE EXPIRED');

      unawaited(_backgroundRefresh());

      return cached;
    }

    _debug('HIVE CACHE MISS | fetching Supabase');

    return _refreshAllModels();
  }

  @override
  Future<List<VocabularyWord>> searchWords(String query) async {
    final safeQuery = query.trim().toLowerCase();

    if (safeQuery.isEmpty) {
      return const [];
    }

    final models = await _getAllModels();

    final filtered = models
        .where((model) {
          return model.dutchWord.toLowerCase().contains(safeQuery) ||
              model.arabicMeaning.toLowerCase().contains(safeQuery) ||
              (model.englishMeaning ?? '').toLowerCase().contains(safeQuery) ||
              model.category.toLowerCase().contains(safeQuery) ||
              model.level.toLowerCase().contains(safeQuery);
        })
        .toList(growable: false);

    return _attachUserState(filtered);
  }

  @override
  Future<VocabularyWord> getWordById(String id) async {
    final models = await _getAllModels();

    VocabularyWordModel? model;

    for (final item in models) {
      if (item.id == id) {
        model = item;
        break;
      }
    }

    model ??= await _remote.getWordById(id);

    final entities = await _attachUserState([model]);

    return entities.first;
  }

  @override
  Future<VocabularyWord> getDailyWord() async {
    final models = await _getAllModels();

    if (models.isEmpty) {
      throw StateError('No vocabulary words available.');
    }

    VocabularyWordModel latest = models.first;

    for (final model in models.skip(1)) {
      final modelDate = model.createdAt;
      final latestDate = latest.createdAt;

      if (modelDate != null &&
          (latestDate == null || modelDate.isAfter(latestDate))) {
        latest = model;
      }
    }

    final entities = await _attachUserState([latest]);

    return entities.first;
  }

  @override
  Future<List<VocabularyWord>> getFavoriteWords() async {
    final userId = _userId;

    if (userId == null) {
      return const [];
    }

    final words = await getWords();

    return words.where((word) => word.isFavorite).toList(growable: false);
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

    await _cache.updateFavorite(
      userId: userId,
      wordId: wordId,
      isFavorite: isFavorite,
    );
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

    await _cache.updateProgress(
      userId: userId,
      wordId: wordId,
      status: status.dbValue,
    );
  }

  @override
  Future<VocabularyStats> getProgressStats() async {
    final words = await getWords();

    var mastered = 0;
    var learning = 0;
    var newWords = 0;

    for (final word in words) {
      switch (word.progressStatus) {
        case VocabularyProgressStatus.mastered:
          mastered++;
          break;

        case VocabularyProgressStatus.learning:
          learning++;
          break;

        case VocabularyProgressStatus.newWord:
          newWords++;
          break;
      }
    }

    return VocabularyStats(
      totalWords: words.length,
      masteredWords: mastered,
      learningWords: learning,
      newWords: newWords,
    );
  }

  @override
  Future<void> refresh() async {
    await _refreshAllModels();
  }

  Future<void> _backgroundRefresh() async {
    try {
      await _refreshAllModels();
    } catch (error, stackTrace) {
      _debug('Background vocabulary refresh failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<List<VocabularyWordModel>> _refreshAllModels() {
    final existingFuture = _refreshWordsFuture;

    if (existingFuture != null) {
      return existingFuture;
    }

    late final Future<List<VocabularyWordModel>> future;

    future = _performRefresh();

    _refreshWordsFuture = future;

    return future.whenComplete(() {
      if (identical(_refreshWordsFuture, future)) {
        _refreshWordsFuture = null;
      }
    });
  }

  Future<List<VocabularyWordModel>> _performRefresh() async {
    final models = await _remote.getWords();

    final now = DateTime.now();

    await _cache.saveWords(models, updatedAt: now);

    _memoryWords = models;
    _memoryWordsUpdatedAt = now;

    final userId = _userId;

    if (userId != null) {
      await _refreshUserState(userId);
    }

    return models;
  }

  Future<List<VocabularyWord>> _attachUserState(
    List<VocabularyWordModel> models,
  ) async {
    if (models.isEmpty) {
      return const [];
    }

    final userId = _userId;

    if (userId == null) {
      return models.map((model) => model.toEntity()).toList(growable: false);
    }

    final userState = await _getUserState(userId);

    return models
        .map((model) {
          final merged = model.copyWith(
            isFavorite: userState.favoriteIds.contains(model.id),
            progressStatus:
                userState.progressMap[model.id] ?? model.progressStatus,
          );

          return merged.toEntity();
        })
        .toList(growable: false);
  }

  Future<VocabularyCachedUserState> _getUserState(String userId) async {
    final cached = await _cache.loadUserState(userId);

    if (cached != null && cached.isFresh(_userStateCacheMaxAge)) {
      return cached;
    }

    await _refreshUserState(userId);

    final refreshed = await _cache.loadUserState(userId);

    return refreshed ??
        const VocabularyCachedUserState(
          favoriteIds: <String>{},
          progressMap: <String, String>{},
          favoriteUpdatedAt: null,
          progressUpdatedAt: null,
        );
  }

  Future<void> _refreshUserState(String userId) async {
    final existing = _userStateRefreshes[userId];

    if (existing != null) {
      await existing;
      return;
    }

    late final Future<void> future;

    future = _performUserStateRefresh(userId);

    _userStateRefreshes[userId] = future;

    try {
      await future;
    } finally {
      if (identical(_userStateRefreshes[userId], future)) {
        _userStateRefreshes.remove(userId);
      }
    }
  }

  Future<void> _performUserStateRefresh(String userId) async {
    try {
      final favoriteIds = await _remote.getFavoriteWordIds(userId);

      await _cache.saveFavoriteIds(userId, favoriteIds);
    } catch (error, stackTrace) {
      _debug('Could not refresh favorite cache: $error');

      debugPrintStack(stackTrace: stackTrace);
    }

    try {
      final progressMap = await _remote.getProgressMap(userId);

      await _cache.saveProgressMap(userId, progressMap);
    } catch (error, stackTrace) {
      _debug('Could not refresh progress cache: $error');

      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _debug(String message) {
    if (kDebugMode) {
      debugPrint('[VOCAB-REPOSITORY] $message');
    }
  }

  @override
  Future<List<VocabularyWord>> getWords({
    String? level,
    String? category,
  }) async {
    final models = await _getAllModels();

    final normalizedLevel = level?.trim().toLowerCase();
    final normalizedCategory = category?.trim().toLowerCase();

    final filtered = models
        .where((model) {
          final levelMatches =
              normalizedLevel == null ||
              normalizedLevel.isEmpty ||
              model.level.trim().toLowerCase() == normalizedLevel;

          final categoryMatches =
              normalizedCategory == null ||
              normalizedCategory.isEmpty ||
              model.category.trim().toLowerCase() == normalizedCategory;

          return levelMatches && categoryMatches;
        })
        .toList(growable: false);

    return _attachUserState(filtered);
  }
}
