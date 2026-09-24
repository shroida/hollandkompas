import 'package:hollandkompas/features/lesson/domain/repositories/lesson_progress_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LessonProgressRepositoryImpl implements LessonProgressRepository {
  LessonProgressRepositoryImpl({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  @override
  Future<bool> getLessonCompletion({
    required String studentId,
    required String lessonId,
  }) async {
    final response = await _supabase
        .from('lesson_progress')
        .select('completed')
        .eq('student_id', studentId)
        .eq('lesson_id', lessonId)
        .maybeSingle();

    return response?['completed'] == true;
  }

  @override
  Future<void> markLessonCompleted({
    required String studentId,
    required String lessonId,
  }) async {
    await _supabase.from('lesson_progress').upsert({
      'student_id': studentId,
      'lesson_id': lessonId,
      'completed': true,
      'completed_at': DateTime.now().toIso8601String(),
    }, onConflict: 'student_id,lesson_id');
  }
}
