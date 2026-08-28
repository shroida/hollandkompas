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

    return CouponModel.fromJson(response);
  }

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
