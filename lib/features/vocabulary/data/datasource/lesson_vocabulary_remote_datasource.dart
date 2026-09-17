import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LessonVocabularyWord {
  const LessonVocabularyWord({
    required this.id,
    required this.lessonId,
    required this.dutchWord,
    required this.arabicMeaning,
    required this.englishMeaning,
    required this.category,
    this.createdAt,
  });

  final String id;
  final String lessonId;
  final String dutchWord;
  final String arabicMeaning;
  final String englishMeaning;
  final String category;
  final DateTime? createdAt;

  factory LessonVocabularyWord.fromMap(Map<String, dynamic> map) {
    return LessonVocabularyWord(
      id: map['id']?.toString() ?? '',
      lessonId: map['lesson_id']?.toString() ?? '',
      dutchWord: map['word']?.toString() ?? '',
      arabicMeaning: map['translation_ar']?.toString() ?? '',
      englishMeaning: map['translation_en']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      createdAt: map['created_at'] == null
          ? null
          : DateTime.tryParse(map['created_at'].toString()),
    );
  }
}

class LessonVocabularyUserState {
  const LessonVocabularyUserState({
    required this.favoriteIds,
    required this.progressMap,
  });

  final Set<String> favoriteIds;
  final Map<String, String> progressMap;

  factory LessonVocabularyUserState.empty() {
    return const LessonVocabularyUserState(
      favoriteIds: <String>{},
      progressMap: <String, String>{},
    );
  }
}

class LessonVocabularyData {
  const LessonVocabularyData({required this.words, required this.userState});

  final List<LessonVocabularyWord> words;
  final LessonVocabularyUserState userState;
}

class LessonVocabularyRemoteDataSource {
  LessonVocabularyRemoteDataSource(this._client, {FlutterTts? tts})
    : _tts = tts ?? FlutterTts();

  final SupabaseClient _client;
  final FlutterTts _tts;

  static const String _vocabulariesTable = 'vocabularies';
  static const String _favoritesTable = 'user_favorite_words';
  static const String _progressTable = 'user_vocabulary_progress';

  void _log(String message) {
    debugPrint('[LESSON-VOCAB] $message');
  }

  Future<void> initialize() async {
    try {
      await _tts.setLanguage('nl-NL');
      await _tts.setSpeechRate(0.42);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      await _tts.awaitSpeakCompletion(true);
    } catch (error, stackTrace) {
      _log('TTS initialize failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<LessonVocabularyData> getLessonVocabulary(String lessonId) async {
    final stopwatch = Stopwatch()..start();

    _log('LOAD START | lesson=$lessonId');

    try {
      final wordsResponse = await _client
          .from(_vocabulariesTable)
          .select('''
            id,
            lesson_id,
            word,
            translation_en,
            translation_ar,
            category,
            created_at
          ''')
          .eq('lesson_id', lessonId)
          .order('id', ascending: true);

      final rows = List<Map<String, dynamic>>.from(wordsResponse);

      final words = rows
          .map(LessonVocabularyWord.fromMap)
          .toList(growable: false);

      _log('WORDS SUCCESS | ${words.length} words');

      final user = _client.auth.currentUser;

      if (user == null || words.isEmpty) {
        stopwatch.stop();

        _log(
          'LOAD SUCCESS | '
          '${stopwatch.elapsedMilliseconds}ms',
        );

        return LessonVocabularyData(
          words: words,
          userState: LessonVocabularyUserState.empty(),
        );
      }

      final userState = await _loadUserState(
        userId: user.id,
        wordIds: words.map((word) => word.id).toList(),
      );

      stopwatch.stop();

      _log(
        'LOAD SUCCESS | '
        '${stopwatch.elapsedMilliseconds}ms | '
        'favorites=${userState.favoriteIds.length} | '
        'progress=${userState.progressMap.length}',
      );

      return LessonVocabularyData(words: words, userState: userState);
    } catch (error, stackTrace) {
      stopwatch.stop();

      _log(
        'LOAD FAILED | '
        '${stopwatch.elapsedMilliseconds}ms | '
        '$error',
      );

      debugPrintStack(stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<LessonVocabularyUserState> _loadUserState({
    required String userId,
    required List<String> wordIds,
  }) async {
    if (wordIds.isEmpty) {
      return LessonVocabularyUserState.empty();
    }

    final results = await Future.wait([
      _loadFavoriteIds(userId: userId, wordIds: wordIds),
      _loadProgressMap(userId: userId, wordIds: wordIds),
    ]);

    return LessonVocabularyUserState(
      favoriteIds: results[0] as Set<String>,
      progressMap: results[1] as Map<String, String>,
    );
  }

  Future<Set<String>> _loadFavoriteIds({
    required String userId,
    required List<String> wordIds,
  }) async {
    try {
      final response = await _client
          .from(_favoritesTable)
          .select('word_id')
          .eq('user_id', userId)
          .inFilter('word_id', wordIds);

      final favoriteIds = <String>{};

      for (final row in response) {
        final wordId = row['word_id']?.toString();

        if (wordId != null && wordId.isNotEmpty) {
          favoriteIds.add(wordId);
        }
      }

      return favoriteIds;
    } catch (error, stackTrace) {
      _log('LOAD FAVORITES FAILED: $error');
      debugPrintStack(stackTrace: stackTrace);

      return <String>{};
    }
  }

  Future<Map<String, String>> _loadProgressMap({
    required String userId,
    required List<String> wordIds,
  }) async {
    try {
      final response = await _client
          .from(_progressTable)
          .select('word_id, status')
          .eq('user_id', userId)
          .inFilter('word_id', wordIds);

      final progressMap = <String, String>{};

      for (final row in response) {
        final wordId = row['word_id']?.toString();
        final status = row['status']?.toString();

        if (wordId != null &&
            wordId.isNotEmpty &&
            status != null &&
            status.isNotEmpty) {
          progressMap[wordId] = status;
        }
      }

      return progressMap;
    } catch (error, stackTrace) {
      _log('LOAD PROGRESS FAILED: $error');
      debugPrintStack(stackTrace: stackTrace);

      return <String, String>{};
    }
  }

  Future<void> setFavorite({
    required String wordId,
    required bool isFavorite,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw StateError('User must be signed in to manage favorite words.');
    }

    _log(
      'FAVORITE '
      'word=$wordId '
      'isFavorite=$isFavorite',
    );

    if (isFavorite) {
      await _client.from(_favoritesTable).upsert({
        'user_id': user.id,
        'word_id': wordId,
      }, onConflict: 'user_id,word_id');
    } else {
      await _client
          .from(_favoritesTable)
          .delete()
          .eq('user_id', user.id)
          .eq('word_id', wordId);
    }
  }

  Future<void> updateProgress({
    required String wordId,
    required String status,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw StateError('User must be signed in to track vocabulary progress.');
    }

    if (!_isValidStatus(status)) {
      throw ArgumentError('Invalid vocabulary status: $status');
    }

    await _client.from(_progressTable).upsert({
      'user_id': user.id,
      'word_id': wordId,
      'status': status,
    }, onConflict: 'user_id,word_id');
  }

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) {
      return;
    }

    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (error, stackTrace) {
      _log('TTS FAILED: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> stopSpeaking() async {
    try {
      await _tts.stop();
    } catch (error) {
      _log('TTS STOP FAILED: $error');
    }
  }

  Future<void> dispose() async {
    try {
      await _tts.stop();
    } catch (error) {
      _log('TTS DISPOSE FAILED: $error');
    }
  }

  bool _isValidStatus(String status) {
    return status == 'new' || status == 'learning' || status == 'mastered';
  }
}
