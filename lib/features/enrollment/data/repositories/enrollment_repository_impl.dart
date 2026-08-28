import 'package:hollandkompas/features/enrollment/data/datasources/enrollment_remote_data_source.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/coupon.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/enrolled_course.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/enrollment.dart';
import 'package:hollandkompas/features/enrollment/domain/repositories/enrollment_repository.dart';
import 'package:image_picker/image_picker.dart';

class EnrollmentRepositoryImpl implements EnrollmentRepository {
  final EnrollmentRemoteDataSource remoteDataSource;

  EnrollmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Coupon?> getCoupon(String code) {
    return remoteDataSource.getCoupon(code);
  }

  @override
  Future<List<EnrolledCourse>> getStudentEnrollments(String studentId) {
    return remoteDataSource.getStudentEnrollments(studentId);
  }

  @override
  Future<Enrollment> createPaymentRequest({
    required String courseId,
    required double originalPrice,
    required double discountPercentage,
    required double discountAmount,
    required double finalPrice,
    required String? couponCode,
    required XFile receipt,
    required String paymentReference,
  }) {
    return remoteDataSource.createPaymentRequest(
      courseId: courseId,
      originalPrice: originalPrice,
      discountPercentage: discountPercentage,
      discountAmount: discountAmount,
      finalPrice: finalPrice,
      couponCode: couponCode,
      receipt: receipt,
      paymentReference: paymentReference,
    );
  }

  @override
  Future<Enrollment?> getStudentEnrollment({
    required String studentId,
    required String courseId,
  }) {
    return remoteDataSource.getStudentEnrollment(
      studentId: studentId,
      courseId: courseId,
    );
  }
}
