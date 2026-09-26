import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/review_stats.dart';
import '../models/flashcard_model.dart';

class FlashcardsRemoteDataSource {
  FlashcardsRemoteDataSource(this._client, {FlutterTts? tts})
    : _tts = tts ?? FlutterTts();

  final SupabaseClient _client;
  final FlutterTts _tts;

  static const String _wordsTable = 'vocabularies';
  static const String _lessonsTable = 'lessons';
  static const String _coursesTable = 'courses';
  static const String _favoritesTable = 'user_favorite_words';
  static const String _progressTable = 'user_vocabulary_progress';

  void _log(String message) {
    debugPrint('[FLASHCARDS] $message');
  }

  Future<void> initialize() async {
    try {
      await _tts.setLanguage('nl-NL');
      await _tts.setSpeechRate(0.42);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      await _tts.awaitSpeakCompletion(true);
    } catch (error, stackTrace) {
      _log('TTS INITIALIZE FAILED: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<List<FlashcardModel>> getFlashcards({
    required bool dueOnly,
    required bool weakOnly,
  }) async {
    final stopwatch = Stopwatch()..start();

    _log(
      'getFlashcards START | '
      'dueOnly=$dueOnly | '
      'weakOnly=$weakOnly | '
      'user=${_client.auth.currentUser?.id}',
    );

    try {
      // ------------------------------------------------------------
      // 1. Fetch vocabulary words
      // ------------------------------------------------------------

      _log('STEP 1: querying $_wordsTable...');

      final response = await _client
          .from(_wordsTable)
          .select('''
            id,
            lesson_id,
            word,
            translation_en,
            translation_ar,
            category,
            created_at
          ''')
          .order('word', ascending: true);

      final rows = List<Map<String, dynamic>>.from(response);

      _log('STEP 1 SUCCESS: ${rows.length} vocabulary rows');

      if (rows.isEmpty) {
        stopwatch.stop();

        _log(
          'getFlashcards END | '
          '${stopwatch.elapsedMilliseconds}ms | '
          '0 cards',
        );

        return const [];
      }

      // ------------------------------------------------------------
      // 2. Collect lesson IDs
      // ------------------------------------------------------------

      final lessonIds = rows
          .map((row) => row['lesson_id']?.toString())
          .whereType<String>()
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      _log('STEP 2: ${lessonIds.length} lesson IDs');

      // ------------------------------------------------------------
      // 3. Fetch lessons
      // ------------------------------------------------------------

      final lessonToCourse = <String, String>{};
      final courseIds = <String>{};

      if (lessonIds.isNotEmpty) {
        _log('STEP 3: querying $_lessonsTable...');

        final lessonsResponse = await _client
            .from(_lessonsTable)
            .select('id, course_id')
            .inFilter('id', lessonIds);

        final lessons = List<Map<String, dynamic>>.from(lessonsResponse);

        _log('STEP 3 SUCCESS: ${lessons.length} lessons');

        for (final lesson in lessons) {
          final lessonId = lesson['id']?.toString();
          final courseId = lesson['course_id']?.toString();

          if (lessonId == null ||
              lessonId.isEmpty ||
              courseId == null ||
              courseId.isEmpty) {
            continue;
          }

          lessonToCourse[lessonId] = courseId;
          courseIds.add(courseId);
        }
      }

      // ------------------------------------------------------------
      // 4. Fetch course levels
      // ------------------------------------------------------------

      final courseToLevel = <String, String>{};

      if (courseIds.isNotEmpty) {
        _log('STEP 4: querying $_coursesTable...');

        final coursesResponse = await _client
            .from(_coursesTable)
            .select('id, level')
            .inFilter('id', courseIds.toList());

        final courses = List<Map<String, dynamic>>.from(coursesResponse);

        _log('STEP 4 SUCCESS: ${courses.length} courses');

        for (final course in courses) {
          final courseId = course['id']?.toString();

          if (courseId == null || courseId.isEmpty) {
            continue;
          }

          courseToLevel[courseId] = course['level']?.toString() ?? '';
        }
      }

      // ------------------------------------------------------------
      // 5. User
      // ------------------------------------------------------------

      final user = _client.auth.currentUser;

      if (user == null) {
        throw StateError('User must be signed in to use flashcards.');
      }

      // ------------------------------------------------------------
      // 6. Word IDs
      // ------------------------------------------------------------

      final wordIds = rows
          .map((row) => row['id']?.toString())
          .whereType<String>()
          .where((id) => id.isNotEmpty)
          .toList();

      // ------------------------------------------------------------
      // 7. Favorites
      // ------------------------------------------------------------

      final favoriteIds = <String>{};

      if (wordIds.isNotEmpty) {
        try {
          final favoritesResponse = await _client
              .from(_favoritesTable)
              .select('word_id')
              .eq('user_id', user.id)
              .inFilter('word_id', wordIds);

          for (final row in favoritesResponse) {
            final wordId = row['word_id']?.toString();

            if (wordId != null && wordId.isNotEmpty) {
              favoriteIds.add(wordId);
            }
          }
        } catch (error, stackTrace) {
          _log('LOAD FAVORITES FAILED: $error');
          debugPrintStack(stackTrace: stackTrace);
        }
      }

      // ------------------------------------------------------------
      // 8. Progress / spaced repetition
      // ------------------------------------------------------------

      final progressMap = <String, Map<String, dynamic>>{};

      if (wordIds.isNotEmpty) {
        try {
          final progressResponse = await _client
              .from(_progressTable)
              .select('''
                word_id,
                status,
                review_count,
                interval_days,
                next_review_at,
                last_reviewed_at,
                forget_count
              ''')
              .eq('user_id', user.id)
              .inFilter('word_id', wordIds);

          for (final row in progressResponse) {
            final wordId = row['word_id']?.toString();

            if (wordId != null && wordId.isNotEmpty) {
              progressMap[wordId] = row;
            }
          }
        } catch (error, stackTrace) {
          _log('LOAD PROGRESS FAILED: $error');
          debugPrintStack(stackTrace: stackTrace);
        }
      }

      // ------------------------------------------------------------
      // 9. Build flashcards
      // ------------------------------------------------------------

      final now = DateTime.now();
      final cards = <FlashcardModel>[];

      for (final row in rows) {
        final id = row['id']?.toString() ?? '';

        if (id.isEmpty) {
          continue;
        }

        final progress = progressMap[id];

        final rawNextReviewAt = progress?['next_review_at'];

        final nextReviewAt = rawNextReviewAt == null
            ? null
            : DateTime.tryParse(rawNextReviewAt.toString());

        final forgetCount = _toInt(progress?['forget_count']);

        // Daily review
        if (dueOnly) {
          if (nextReviewAt != null && nextReviewAt.isAfter(now)) {
            continue;
          }
        }

        // Weak words
        if (weakOnly && forgetCount == 0) {
          continue;
        }

        final lessonId = row['lesson_id']?.toString();

        final courseId = lessonId == null ? null : lessonToCourse[lessonId];

        final level = courseId == null ? '' : courseToLevel[courseId] ?? '';

        cards.add(
          FlashcardModel.fromMap({
            ...row,
            'level': level,
            'is_favorite': favoriteIds.contains(id),
            'status': progress?['status'] ?? 'new',
            'review_count': progress?['review_count'] ?? 0,
            'interval_days': progress?['interval_days'] ?? 0,
            'next_review_at': progress?['next_review_at'],
            'last_reviewed_at': progress?['last_reviewed_at'],
            'forget_count': progress?['forget_count'] ?? 0,
          }),
        );
      }

      stopwatch.stop();

      _log(
        'getFlashcards SUCCESS | '
        '${stopwatch.elapsedMilliseconds}ms | '
        '${cards.length} cards',
      );

      return cards;
    } catch (error, stackTrace) {
      stopwatch.stop();

      _log(
        'getFlashcards FAILED | '
        '${stopwatch.elapsedMilliseconds}ms | '
        '$error',
      );

      debugPrintStack(stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<void> reviewFlashcard({
    required String wordId,
    required bool remembered,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw StateError('User must be signed in to review flashcards.');
    }

    final currentResponse = await _client
        .from(_progressTable)
        .select('''
          status,
          review_count,
          interval_days,
          forget_count
        ''')
        .eq('user_id', user.id)
        .eq('word_id', wordId)
        .maybeSingle();

    final current = currentResponse ?? <String, dynamic>{};

    final reviewCount = _toInt(current['review_count']);

    final currentInterval = _toInt(current['interval_days']);

    final forgetCount = _toInt(current['forget_count']);

    final now = DateTime.now();

    late int nextInterval;
    late int nextForgetCount;
    late String status;

    if (remembered) {
      nextInterval = _calculateRememberInterval(
        reviewCount: reviewCount,
        currentInterval: currentInterval,
      );

      nextForgetCount = forgetCount;

      status = nextInterval >= 14 ? 'mastered' : 'learning';
    } else {
      nextInterval = _calculateForgetInterval(currentInterval: currentInterval);

      nextForgetCount = forgetCount + 1;

      status = 'learning';
    }

    final nextReviewAt = now.add(Duration(days: nextInterval));

    await _client.from(_progressTable).upsert({
      'user_id': user.id,
      'word_id': wordId,
      'status': status,
      'review_count': reviewCount + 1,
      'interval_days': nextInterval,
      'next_review_at': nextReviewAt.toUtc().toIso8601String(),
      'last_reviewed_at': now.toUtc().toIso8601String(),
      'forget_count': nextForgetCount,
    }, onConflict: 'user_id,word_id');
  }

  Future<ReviewStats> getReviewStats() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      return const ReviewStats(
        total: 0,
        dueToday: 0,
        weakWords: 0,
        mastered: 0,
      );
    }

    try {
      final response = await _client
          .from(_progressTable)
          .select('''
          status,
          next_review_at,
          forget_count
        ''')
          .eq('user_id', user.id);

      final rows = List<Map<String, dynamic>>.from(response);

      final now = DateTime.now();

      var dueToday = 0;
      var weakWords = 0;
      var mastered = 0;

      for (final row in rows) {
        final rawNextReviewAt = row['next_review_at'];

        final nextReviewAt = rawNextReviewAt == null
            ? null
            : DateTime.tryParse(rawNextReviewAt.toString());

        if (nextReviewAt == null || !nextReviewAt.isAfter(now)) {
          dueToday++;
        }

        if (_toInt(row['forget_count']) > 0) {
          weakWords++;
        }

        if (row['status'] == 'mastered') {
          mastered++;
        }
      }

      return ReviewStats(
        total: rows.length,
        dueToday: dueToday,
        weakWords: weakWords,
        mastered: mastered,
      );
    } catch (error, stackTrace) {
      _log('GET REVIEW STATS FAILED: $error');
      debugPrintStack(stackTrace: stackTrace);

      return const ReviewStats(
        total: 0,
        dueToday: 0,
        weakWords: 0,
        mastered: 0,
      );
    }
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

  int _calculateRememberInterval({
    required int reviewCount,
    required int currentInterval,
  }) {
    if (reviewCount == 0) {
      return 1;
    }

    if (currentInterval <= 0) {
      return 1;
    }

    if (currentInterval == 1) {
      return 3;
    }

    if (currentInterval == 3) {
      return 7;
    }

    if (currentInterval == 7) {
      return 14;
    }

    if (currentInterval == 14) {
      return 30;
    }

    return (currentInterval * 2).clamp(1, 365);
  }

  int _calculateForgetInterval({required int currentInterval}) {
    if (currentInterval <= 1) {
      return 1;
    }

    return (currentInterval ~/ 2).clamp(1, 7);
  }

  int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
