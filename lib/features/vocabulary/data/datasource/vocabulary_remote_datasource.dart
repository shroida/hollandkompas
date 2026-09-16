import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/vocabulary_word_model.dart';

abstract class VocabularyRemoteDataSource {
  Future<List<VocabularyWordModel>> getWords({String? level, String? category});

  Future<List<VocabularyWordModel>> searchWords(String query);

  Future<VocabularyWordModel> getWordById(String id);

  Future<VocabularyWordModel> getDailyWord();

  Future<Set<String>> getFavoriteWordIds(String userId);

  Future<Map<String, String>> getProgressMap(String userId);

  Future<void> addFavorite(String userId, String wordId);

  Future<void> removeFavorite(String userId, String wordId);

  Future<void> upsertProgress(String userId, String wordId, String status);
}

class VocabularyRemoteDataSourceImpl implements VocabularyRemoteDataSource {
  VocabularyRemoteDataSourceImpl(this._client);

  final SupabaseClient _client;

  static const String _wordsTable = 'vocabularies';
  static const String _lessonsTable = 'lessons';
  static const String _coursesTable = 'courses';
  static const String _favoritesTable = 'user_favorite_words';
  static const String _progressTable = 'user_vocabulary_progress';

  void _log(String message) {
    debugPrint('[VOCABULARY] $message');
  }

  @override
  Future<List<VocabularyWordModel>> getWords({
    String? level,
    String? category,
  }) async {
    final stopwatch = Stopwatch()..start();

    _log(
      'getWords START | '
      'level=$level | category=$category | '
      'user=${_client.auth.currentUser?.id}',
    );

    try {
      // ------------------------------------------------------------
      // 1. Fetch vocabularies
      // ------------------------------------------------------------

      _log('STEP 1: querying $_wordsTable...');

      var query = _client.from(_wordsTable).select('''
            id,
            lesson_id,
            word,
            translation_en,
            translation_ar,
            category,
            created_at
          ''');

      if (category != null && category.trim().isNotEmpty) {
        _log('Applying category filter: ${category.trim()}');

        query = query.eq('category', category.trim());
      }

      final response = await query.order('word', ascending: true);

      final rows = List<Map<String, dynamic>>.from(response);

      _log('STEP 1 SUCCESS: ${rows.length} vocabulary rows');

      if (rows.isEmpty) {
        _log('No vocabulary rows found.');
        stopwatch.stop();
        _log('getWords END in ${stopwatch.elapsedMilliseconds}ms');
        return const [];
      }

      _log('First row: ${rows.first}');

      // ------------------------------------------------------------
      // 2. Collect lesson IDs
      // ------------------------------------------------------------

      final lessonIds = rows
          .map((row) => row['lesson_id']?.toString())
          .where((id) => id != null && id.isNotEmpty)
          .cast<String>()
          .toSet()
          .toList();

      _log('STEP 2: found ${lessonIds.length} unique lesson IDs');

      if (lessonIds.isEmpty) {
        _log('WARNING: vocabularies have no lesson_id values.');

        final models = rows
            .where((row) {
              return level == null || level.trim().isEmpty;
            })
            .map((row) => _mapRowToModel(row, levelValue: ''))
            .toList();

        _log('Built ${models.length} models without levels.');

        stopwatch.stop();
        _log('getWords END in ${stopwatch.elapsedMilliseconds}ms');

        return models;
      }

      // ------------------------------------------------------------
      // 3. Fetch lessons
      // ------------------------------------------------------------

      _log('STEP 3: querying $_lessonsTable...');

      final lessonsResponse = await _client
          .from(_lessonsTable)
          .select('id, course_id')
          .inFilter('id', lessonIds);

      final lessons = List<Map<String, dynamic>>.from(lessonsResponse);

      _log('STEP 3 SUCCESS: ${lessons.length} lessons');

      if (lessons.isNotEmpty) {
        _log('First lesson: ${lessons.first}');
      }

      // ------------------------------------------------------------
      // 4. Build lesson -> course map
      // ------------------------------------------------------------

      final lessonToCourse = <String, String>{};
      final courseIds = <String>{};

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

      _log(
        'STEP 4: mapped ${lessonToCourse.length} lessons '
        'to ${courseIds.length} courses',
      );

      // ------------------------------------------------------------
      // 5. Fetch courses
      // ------------------------------------------------------------

      final courseToLevel = <String, String>{};

      if (courseIds.isNotEmpty) {
        _log('STEP 5: querying $_coursesTable...');

        final coursesResponse = await _client
            .from(_coursesTable)
            .select('id, level')
            .inFilter('id', courseIds.toList());

        final courses = List<Map<String, dynamic>>.from(coursesResponse);

        _log('STEP 5 SUCCESS: ${courses.length} courses');

        if (courses.isNotEmpty) {
          _log('First course: ${courses.first}');
        }

        for (final course in courses) {
          final courseId = course['id']?.toString();

          if (courseId == null || courseId.isEmpty) {
            continue;
          }

          courseToLevel[courseId] = course['level']?.toString() ?? '';
        }
      } else {
        _log('WARNING: no course IDs found.');
      }

      _log(
        'STEP 5 RESULT: ${courseToLevel.length} '
        'course levels mapped',
      );

      // ------------------------------------------------------------
      // 6. Convert rows -> models
      // ------------------------------------------------------------

      final models = <VocabularyWordModel>[];

      for (final row in rows) {
        final lessonId = row['lesson_id']?.toString();

        final courseId = lessonId == null ? null : lessonToCourse[lessonId];

        final levelValue = courseId == null
            ? ''
            : courseToLevel[courseId] ?? '';

        if (level != null &&
            level.trim().isNotEmpty &&
            levelValue.toUpperCase() != level.trim().toUpperCase()) {
          continue;
        }

        try {
          final model = _mapRowToModel(row, levelValue: levelValue);

          models.add(model);
        } catch (error, stackTrace) {
          _log('MODEL ERROR for row ${row['id']}: $error');
          debugPrintStack(stackTrace: stackTrace);
          rethrow;
        }
      }

      _log('STEP 6 SUCCESS: ${models.length} models created');

      if (models.isNotEmpty) {
        _log('First model: ${models.first}');
      }

      stopwatch.stop();

      _log(
        'getWords SUCCESS in '
        '${stopwatch.elapsedMilliseconds}ms',
      );

      return models;
    } catch (error, stackTrace) {
      stopwatch.stop();

      _log(
        'getWords FAILED after '
        '${stopwatch.elapsedMilliseconds}ms',
      );

      _log('ERROR TYPE: ${error.runtimeType}');

      _log('ERROR: $error');

      debugPrintStack(stackTrace: stackTrace);

      rethrow;
    }
  }

  @override
  Future<List<VocabularyWordModel>> searchWords(String query) async {
    _log('searchWords START | query="$query"');

    try {
      final safeQuery = query.trim();

      if (safeQuery.isEmpty) {
        _log('searchWords: empty query');
        return const [];
      }

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
          .or(
            'word.ilike.%$safeQuery%,'
            'translation_ar.ilike.%$safeQuery%,'
            'translation_en.ilike.%$safeQuery%',
          )
          .order('word', ascending: true);

      final rows = List<Map<String, dynamic>>.from(response);

      _log('searchWords: ${rows.length} rows');

      final models = <VocabularyWordModel>[];

      for (final row in rows) {
        models.add(_mapRowToModel(row, levelValue: ''));
      }

      _log('searchWords SUCCESS: ${models.length} models');

      return models;
    } catch (error, stackTrace) {
      _log('searchWords FAILED: $error');

      debugPrintStack(stackTrace: stackTrace);

      rethrow;
    }
  }

  @override
  Future<VocabularyWordModel> getWordById(String id) async {
    _log('getWordById START | id=$id');

    try {
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
          .eq('id', id)
          .single();

      final row = Map<String, dynamic>.from(response);

      final lessonId = row['lesson_id']?.toString();

      String levelValue = '';

      if (lessonId != null && lessonId.isNotEmpty) {
        final lesson = await _client
            .from(_lessonsTable)
            .select('course_id')
            .eq('id', lessonId)
            .maybeSingle();

        final courseId = lesson?['course_id']?.toString();

        if (courseId != null && courseId.isNotEmpty) {
          final course = await _client
              .from(_coursesTable)
              .select('level')
              .eq('id', courseId)
              .maybeSingle();

          levelValue = course?['level']?.toString() ?? '';
        }
      }

      final model = _mapRowToModel(row, levelValue: levelValue);

      _log(
        'getWordById SUCCESS | '
        '${model.dutchWord}',
      );

      return model;
    } catch (error, stackTrace) {
      _log('getWordById FAILED: $error');

      debugPrintStack(stackTrace: stackTrace);

      rethrow;
    }
  }

  @override
  Future<VocabularyWordModel> getDailyWord() async {
    _log('getDailyWord START');

    try {
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
          .order('created_at', ascending: false)
          .limit(1)
          .single();

      final row = Map<String, dynamic>.from(response);

      final lessonId = row['lesson_id']?.toString();

      String levelValue = '';

      if (lessonId != null && lessonId.isNotEmpty) {
        final lesson = await _client
            .from(_lessonsTable)
            .select('course_id')
            .eq('id', lessonId)
            .maybeSingle();

        final courseId = lesson?['course_id']?.toString();

        if (courseId != null && courseId.isNotEmpty) {
          final course = await _client
              .from(_coursesTable)
              .select('level')
              .eq('id', courseId)
              .maybeSingle();

          levelValue = course?['level']?.toString() ?? '';
        }
      }

      final model = _mapRowToModel(row, levelValue: levelValue);

      _log('getDailyWord SUCCESS | ${model.dutchWord}');

      return model;
    } catch (error, stackTrace) {
      _log('getDailyWord FAILED: $error');

      debugPrintStack(stackTrace: stackTrace);

      rethrow;
    }
  }

  VocabularyWordModel _mapRowToModel(
    Map<String, dynamic> row, {
    required String levelValue,
  }) {
    return VocabularyWordModel.fromJson({
      'id': row['id'],
      'lesson_id': row['lesson_id'],
      'word': row['word'],
      'translation_en': row['translation_en'],
      'translation_ar': row['translation_ar'],
      'category': row['category'],
      'created_at': row['created_at'],
      'level': levelValue,
    });
  }

  @override
  Future<Set<String>> getFavoriteWordIds(String userId) async {
    _log('getFavoriteWordIds START | user=$userId');

    try {
      final response = await _client
          .from(_favoritesTable)
          .select('word_id')
          .eq('user_id', userId);

      final ids = response
          .map<String>((row) => row['word_id'].toString())
          .toSet();

      _log(
        'getFavoriteWordIds SUCCESS | '
        '${ids.length} favorites',
      );

      return ids;
    } catch (error, stackTrace) {
      _log('getFavoriteWordIds FAILED: $error');

      debugPrintStack(stackTrace: stackTrace);

      rethrow;
    }
  }

  @override
  Future<Map<String, String>> getProgressMap(String userId) async {
    _log('getProgressMap START | user=$userId');

    try {
      final response = await _client
          .from(_progressTable)
          .select('word_id, status')
          .eq('user_id', userId);

      final map = <String, String>{
        for (final row in response)
          row['word_id'].toString(): row['status'].toString(),
      };

      _log(
        'getProgressMap SUCCESS | '
        '${map.length} progress rows',
      );

      return map;
    } catch (error, stackTrace) {
      _log('getProgressMap FAILED: $error');

      debugPrintStack(stackTrace: stackTrace);

      rethrow;
    }
  }

  @override
  Future<void> addFavorite(String userId, String wordId) async {
    _log('addFavorite | user=$userId | word=$wordId');

    await _client.from(_favoritesTable).upsert({
      'user_id': userId,
      'word_id': wordId,
    });
  }

  @override
  Future<void> removeFavorite(String userId, String wordId) async {
    _log('removeFavorite | user=$userId | word=$wordId');

    await _client
        .from(_favoritesTable)
        .delete()
        .eq('user_id', userId)
        .eq('word_id', wordId);
  }

  @override
  Future<void> upsertProgress(
    String userId,
    String wordId,
    String status,
  ) async {
    _log(
      'upsertProgress | '
      'user=$userId | word=$wordId | status=$status',
    );

    await _client.from(_progressTable).upsert({
      'user_id': userId,
      'word_id': wordId,
      'status': status,
    });
  }
}
