import 'package:hollandkompas/features/enrollment/domain/entities/coupon.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/enrolled_course.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/enrollment.dart';
import 'package:image_picker/image_picker.dart';

abstract class EnrollmentRepository {
  Future<Coupon?> getCoupon(String code);

  Future<List<EnrolledCourse>> getStudentEnrollments(String studentId);
  Future<Enrollment> createPaymentRequest({
    required String courseId,
    required double originalPrice,
    required double discountPercentage,
    required double discountAmount,
    required double finalPrice,
    required String? couponCode,
    required XFile receipt,
    required String paymentReference,
  });
  Future<Enrollment?> getStudentEnrollment({
    required String studentId,
    required String courseId,
  });
}
