import 'package:hollandkompas/features/home/data/models/lesson_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class LessonRemoteDataSource {
  Future<List<LessonModel>> getCourseLessons(String courseId);
}

class LessonRemoteDataSourceImpl implements LessonRemoteDataSource {
  final SupabaseClient supabase;

  LessonRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<LessonModel>> getCourseLessons(String courseId) async {
    final response = await supabase
        .from('lessons')
        .select()
        .eq('course_id', courseId)
        .order('lesson_order', ascending: true);

    return response
        .map<LessonModel>(
          (json) => LessonModel.fromJson(Map<String, dynamic>.from(json)),
        )
        .toList();
  }
}
