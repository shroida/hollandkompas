import 'package:hollandkompas/features/home/data/datasource/enrollment_remote_data_source.dart';
import 'package:hollandkompas/features/home/domain/entities/enrolled_course.dart';
import 'package:hollandkompas/features/home/domain/repositories/enrollment_repository.dart';

class EnrollmentRepositoryImpl implements EnrollmentRepository {
  final EnrollmentRemoteDataSource remoteDataSource;

  EnrollmentRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<EnrolledCourse>> getStudentEnrollments(String studentId) {
    return remoteDataSource.getStudentEnrollments(studentId);
  }
}
