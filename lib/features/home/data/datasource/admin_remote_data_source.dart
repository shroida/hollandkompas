import 'package:hollandkompas/features/home/data/models/recent_course_model.dart';
import 'package:hollandkompas/features/home/data/models/recent_student_model.dart';

abstract interface class AdminRemoteDataSource {
  Future<int> getStudentsCount();

  Future<int> getCoursesCount();

  Future<int> getLessonsCount();

  Future<int> getEnrollmentsCount();

  Future<List<RecentStudentModel>> getRecentStudents();

  Future<List<RecentCourseModel>> getRecentCourses();
}
