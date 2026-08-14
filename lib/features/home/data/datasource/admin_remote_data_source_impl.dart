import 'package:hollandkompas/core/network/supabase_client.dart';
import 'package:hollandkompas/features/home/data/datasource/admin_remote_data_source.dart';
import 'package:hollandkompas/features/home/data/models/recent_course_model.dart';
import 'package:hollandkompas/features/home/data/models/recent_student_model.dart';

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final supabase = SupabaseManager.client;

  @override
  Future<int> getStudentsCount() async {
    final response = await supabase
        .from('profiles')
        .select('id')
        .eq('role', 'student');

    return response.length;
  }

  @override
  Future<int> getCoursesCount() async {
    final response = await supabase.from('courses').select('id');

    return response.length;
  }

  @override
  Future<int> getLessonsCount() async {
    final response = await supabase.from('lessons').select('id');

    return response.length;
  }

  @override
  Future<int> getEnrollmentsCount() async {
    final response = await supabase.from('enrollments').select('id');

    return response.length;
  }

  @override
  Future<List<RecentStudentModel>> getRecentStudents() async {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('role', 'student')
        .order('created_at', ascending: false)
        .limit(5);

    return response.map((e) => RecentStudentModel.fromMap(e)).toList();
  }

  @override
  Future<List<RecentCourseModel>> getRecentCourses() async {
    final response = await supabase
        .from('courses')
        .select()
        .order('created_at', ascending: false)
        .limit(5);

    return response.map((e) => RecentCourseModel.fromMap(e)).toList();
  }
}
