import 'package:hollandkompas/features/enrollment/domain/entities/enrolled_course.dart';

import '../../domain/entities/coupon.dart';
import '../../domain/repositories/enrollment_repository.dart';
import '../datasources/enrollment_remote_data_source.dart';

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
