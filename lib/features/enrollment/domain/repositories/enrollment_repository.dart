import 'package:hollandkompas/features/enrollment/domain/entities/enrolled_course.dart';

import '../entities/coupon.dart';

abstract class EnrollmentRepository {
  Future<Coupon?> getCoupon(String code);
  Future<List<EnrolledCourse>> getStudentEnrollments(String studentId);
}
