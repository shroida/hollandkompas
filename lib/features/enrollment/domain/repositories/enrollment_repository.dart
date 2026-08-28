import 'package:hollandkompas/features/enrollment/domain/entities/coupon.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/enrolled_course.dart';

abstract class EnrollmentRepository {
  Future<Coupon?> getCoupon(String code);

  Future<List<EnrolledCourse>> getStudentEnrollments(String studentId);
}
