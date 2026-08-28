import 'package:hollandkompas/features/enrollment/data/datasources/enrollment_remote_data_source.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/coupon.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/enrolled_course.dart';
import 'package:hollandkompas/features/enrollment/domain/repositories/enrollment_repository.dart';

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
}
