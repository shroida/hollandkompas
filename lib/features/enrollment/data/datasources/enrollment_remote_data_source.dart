import 'package:hollandkompas/features/enrollment/data/models/coupon_model.dart';
import 'package:hollandkompas/features/enrollment/data/models/enrolled_course_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class EnrollmentRemoteDataSource {
  Future<CouponModel?> getCoupon(String code);

  Future<List<EnrolledCourseModel>> getStudentEnrollments(String studentId);
}

class EnrollmentRemoteDataSourceImpl implements EnrollmentRemoteDataSource {
  final SupabaseClient supabase;

  EnrollmentRemoteDataSourceImpl({required this.supabase});

  @override
  Future<CouponModel?> getCoupon(String code) async {
    final response = await supabase
        .from('coupons')
        .select('code, percentage, is_active, expires_at')
        .eq('code', code)
        .eq('is_active', true)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return CouponModel.fromJson(Map<String, dynamic>.from(response));
  }

  @override
  Future<List<EnrolledCourseModel>> getStudentEnrollments(
    String studentId,
  ) async {
    // ------------------------------------------------------------
    // 1. Get student's enrollments + course information
    // ------------------------------------------------------------

    final enrollmentResponse = await supabase
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
            updated_at,
            price
          )
        ''')
        .eq('student_id', studentId)
        .order('enrolled_at', ascending: false);

    final enrollments = List<Map<String, dynamic>>.from(enrollmentResponse);

    if (enrollments.isEmpty) {
      return [];
    }

    final result = <EnrolledCourseModel>[];

    // ------------------------------------------------------------
    // 2. For every enrollment:
    //    - Get all lessons of the course
    //    - Get completed lessons of the student
    // ------------------------------------------------------------

    for (final enrollment in enrollments) {
      final rawCourse = enrollment['courses'];

      if (rawCourse == null) {
        continue;
      }

      final course = Map<String, dynamic>.from(rawCourse);

      final courseId = enrollment['course_id'] as String;

      // ----------------------------------------------------------
      // Get total lessons
      // ----------------------------------------------------------

      final lessonsResponse = await supabase
          .from('lessons')
          .select('id')
          .eq('course_id', courseId);

      final lessons = List<Map<String, dynamic>>.from(lessonsResponse);

      final totalLessons = lessons.length;

      // ----------------------------------------------------------
      // Get completed lessons
      // ----------------------------------------------------------

      int completedLessons = 0;

      if (lessons.isNotEmpty) {
        final lessonIds = lessons
            .map((lesson) => lesson['id'] as String)
            .toList();

        final progressResponse = await supabase
            .from('lesson_progress')
            .select('lesson_id, completed')
            .eq('student_id', studentId)
            .eq('completed', true)
            .inFilter('lesson_id', lessonIds);

        completedLessons = progressResponse.length;
      }

      // ----------------------------------------------------------
      // Build model
      // ----------------------------------------------------------

      result.add(
        EnrolledCourseModel.fromJson(
          enrollment,
          course: course,
          totalLessons: totalLessons,
          completedLessons: completedLessons,
        ),
      );
    }

    return result;
  }
}
