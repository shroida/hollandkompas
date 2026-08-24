import 'package:hollandkompas/features/home/data/models/enrolled_course_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class EnrollmentRemoteDataSource {
  Future<List<EnrolledCourseModel>> getStudentEnrollments(String studentId);
}

class EnrollmentRemoteDataSourceImpl implements EnrollmentRemoteDataSource {
  final SupabaseClient supabase;

  EnrollmentRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<EnrolledCourseModel>> getStudentEnrollments(
    String studentId,
  ) async {
    final response = await supabase
        .from('enrollments')
        .select('''
          id,
          student_id,
          course_id,
          enrolled_at,
          courses (
            id,
            title,
            description,
            level,
            image_url,
            is_published,
            created_by,
            created_at,
            updated_at
          )
        ''')
        .eq('student_id', studentId)
        .order('enrolled_at', ascending: false);

    return (response as List)
        .map(
          (json) =>
              EnrolledCourseModel.fromJson(Map<String, dynamic>.from(json)),
        )
        .toList();
  }
}
