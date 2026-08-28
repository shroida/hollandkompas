import 'package:hollandkompas/features/enrollment/domain/entities/enrolled_course.dart';

abstract class EnrollmentRepository {
  Future<List<EnrolledCourse>> getStudentEnrollments(String studentId);
}
