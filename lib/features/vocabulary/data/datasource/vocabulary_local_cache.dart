import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/vocabulary_word_model.dart';

/// Lightweight Hive cache of the full (unfiltered) word list, so the
/// Vocabulary Database screen still has something to show — the last
/// successful fetch — when the device is offline. Deliberately simple:
/// it stores one JSON blob under one key rather than a box entry per
/// word, since the whole list is small.
class VocabularyLocalCache {
  static const boxName = 'vocabulary_cache';
  static const _allWordsKey = 'all_words';

  Future<Box> _openBox() => Hive.openBox(boxName);

  Future<void> saveWords(List<VocabularyWordModel> words) async {
    final box = await _openBox();
    final raw = jsonEncode(words.map((w) => w.toJson()).toList());
    await box.put(_allWordsKey, raw);
  }

  Future<List<VocabularyWordModel>> loadWords() async {
    final box = await _openBox();
    final raw = box.get(_allWordsKey) as String?;
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List;
    return decoded
        .map((e) => VocabularyWordModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
