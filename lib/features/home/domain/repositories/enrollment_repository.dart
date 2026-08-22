import 'package:hollandkompas/features/home/domain/entities/enrolled_course.dart';

abstract class EnrollmentRepository {
  Future<List<EnrolledCourse>> getStudentEnrollments(String studentId);
}
