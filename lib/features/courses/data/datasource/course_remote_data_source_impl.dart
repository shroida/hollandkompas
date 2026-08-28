import 'package:hollandkompas/features/courses/data/datasource/course_remote_data_source.dart';
import 'package:hollandkompas/features/home/data/models/course_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final SupabaseClient supabase;

  CourseRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<CourseModel>> getPublishedCourses() async {
    final response = await supabase
        .from('courses')
        .select()
        .eq('is_published', true)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => CourseModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }
}
