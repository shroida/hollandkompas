import 'package:hollandkompas/features/home/domain/entities/dashboard_statistics.dart';
import 'package:hollandkompas/features/home/domain/entities/recent_course.dart';
import 'package:hollandkompas/features/home/domain/entities/recent_student.dart';
import 'package:hollandkompas/features/home/domain/entities/student.dart';

abstract interface class AdminDashboardRepository {
  Future<DashboardStatistics> getDashboardStatistics();

  Future<List<RecentStudent>> getRecentStudents();

  Future<List<RecentCourse>> getRecentCourses();

  Future<List<Student>> getAllStudents();
}
