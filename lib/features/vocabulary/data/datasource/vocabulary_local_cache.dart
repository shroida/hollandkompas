import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/vocabulary_word_model.dart';

class VocabularyCachedUserState {
  const VocabularyCachedUserState({
    required this.favoriteIds,
    required this.progressMap,
    required this.favoriteUpdatedAt,
    required this.progressUpdatedAt,
  });

  final Set<String> favoriteIds;
  final Map<String, String> progressMap;
  final DateTime? favoriteUpdatedAt;
  final DateTime? progressUpdatedAt;

  bool isFresh(Duration maxAge) {
    if (favoriteUpdatedAt == null || progressUpdatedAt == null) {
      return false;
    }

    final now = DateTime.now();

    return now.difference(favoriteUpdatedAt!).abs() <= maxAge &&
        now.difference(progressUpdatedAt!).abs() <= maxAge;
  }
}

class VocabularyLocalCache {
  static const String boxName = 'vocabulary_cache';

  static const String _allWordsKey = 'all_words';
  static const String _allWordsUpdatedAtKey = 'all_words_updated_at';

  static const String _favoritesPrefix = 'favorites_';
  static const String _favoritesUpdatedAtPrefix = 'favorites_updated_at_';

  static const String _progressPrefix = 'progress_';
  static const String _progressUpdatedAtPrefix = 'progress_updated_at_';

  Box? _box;

  Future<Box> _openBox() async {
    final existing = _box;

    if (existing != null && existing.isOpen) {
      return existing;
    }

    final box = await Hive.openBox(boxName);
    _box = box;

    return box;
  }

  String _favoritesKey(String userId) {
    return '$_favoritesPrefix$userId';
  }

  String _favoritesUpdatedAtKey(String userId) {
    return '$_favoritesUpdatedAtPrefix$userId';
  }

  String _progressKey(String userId) {
    return '$_progressPrefix$userId';
  }

  String _progressUpdatedAtKey(String userId) {
    return '$_progressUpdatedAtPrefix$userId';
  }

  Future<void> saveWords(
    List<VocabularyWordModel> words, {
    DateTime? updatedAt,
  }) async {
    final box = await _openBox();

    final raw = jsonEncode(words.map((word) => word.toJson()).toList());

    await box.put(_allWordsKey, raw);
    await box.put(
      _allWordsUpdatedAtKey,
      (updatedAt ?? DateTime.now()).millisecondsSinceEpoch,
    );
  }

  Future<List<VocabularyWordModel>> loadWords() async {
    final box = await _openBox();

    final raw = box.get(_allWordsKey);

    if (raw is! String || raw.isEmpty) {
      return const [];
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is! List) {
        return const [];
      }

      return decoded
          .whereType<Map>()
          .map(
            (item) =>
                VocabularyWordModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  Future<DateTime?> loadWordsUpdatedAt() async {
    final box = await _openBox();

    final value = box.get(_allWordsUpdatedAtKey);

    if (value is! int) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  Future<void> saveFavoriteIds(
    String userId,
    Set<String> ids, {
    DateTime? updatedAt,
  }) async {
    final box = await _openBox();

    await box.put(
      _favoritesKey(userId),
      jsonEncode(ids.toList(growable: false)),
    );

    await box.put(
      _favoritesUpdatedAtKey(userId),
      (updatedAt ?? DateTime.now()).millisecondsSinceEpoch,
    );
  }

  Future<Set<String>?> loadFavoriteIds(String userId) async {
    final box = await _openBox();

    final raw = box.get(_favoritesKey(userId));

    if (raw is! String || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is! List) {
        return null;
      }

      return decoded
          .map((value) => value.toString())
          .where((value) => value.isNotEmpty)
          .toSet();
    } catch (_) {
      return null;
    }
  }

  Future<DateTime?> loadFavoriteUpdatedAt(String userId) async {
    final box = await _openBox();

    final value = box.get(_favoritesUpdatedAtKey(userId));

    if (value is! int) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  Future<void> saveProgressMap(
    String userId,
    Map<String, String> progressMap, {
    DateTime? updatedAt,
  }) async {
    final box = await _openBox();

    await box.put(_progressKey(userId), jsonEncode(progressMap));

    await box.put(
      _progressUpdatedAtKey(userId),
      (updatedAt ?? DateTime.now()).millisecondsSinceEpoch,
    );
  }

  Future<Map<String, String>?> loadProgressMap(String userId) async {
    final box = await _openBox();

    final raw = box.get(_progressKey(userId));

    if (raw is! String || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is! Map) {
        return null;
      }

      return decoded.map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      );
    } catch (_) {
      return null;
    }
  }

  Future<DateTime?> loadProgressUpdatedAt(String userId) async {
    final box = await _openBox();

    final value = box.get(_progressUpdatedAtKey(userId));

    if (value is! int) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  Future<VocabularyCachedUserState?> loadUserState(String userId) async {
    final favoriteIds = await loadFavoriteIds(userId);
    final progressMap = await loadProgressMap(userId);

    if (favoriteIds == null && progressMap == null) {
      return null;
    }

    final favoriteUpdatedAt = await loadFavoriteUpdatedAt(userId);
    final progressUpdatedAt = await loadProgressUpdatedAt(userId);

    return VocabularyCachedUserState(
      favoriteIds: favoriteIds ?? <String>{},
      progressMap: progressMap ?? <String, String>{},
      favoriteUpdatedAt: favoriteUpdatedAt,
      progressUpdatedAt: progressUpdatedAt,
    );
  }

  Future<void> updateFavorite({
    required String userId,
    required String wordId,
    required bool isFavorite,
  }) async {
    final current = await loadFavoriteIds(userId) ?? <String>{};

    if (isFavorite) {
      current.add(wordId);
    } else {
      current.remove(wordId);
    }

    await saveFavoriteIds(userId, current);
  }

  Future<void> updateProgress({
    required String userId,
    required String wordId,
    required String status,
  }) async {
    final current = await loadProgressMap(userId) ?? <String, String>{};

    current[wordId] = status;

    await saveProgressMap(userId, current);
  }

  Future<void> clearUserState(String userId) async {
    final box = await _openBox();

    await box.delete(_favoritesKey(userId));
    await box.delete(_favoritesUpdatedAtKey(userId));
    await box.delete(_progressKey(userId));
    await box.delete(_progressUpdatedAtKey(userId));
  }

  Future<void> clearAll() async {
    final box = await _openBox();

    await box.delete(_allWordsKey);
    await box.delete(_allWordsUpdatedAtKey);

    final keys = box.keys.toList();

    for (final key in keys) {
      final keyString = key.toString();

      if (keyString.startsWith(_favoritesPrefix) ||
          keyString.startsWith(_favoritesUpdatedAtPrefix) ||
          keyString.startsWith(_progressPrefix) ||
          keyString.startsWith(_progressUpdatedAtPrefix)) {
        await box.delete(key);
      }
    }
  }
}
