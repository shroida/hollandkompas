import 'package:hollandkompas/features/home/data/datasource/admin_remote_data_source.dart';
import 'package:hollandkompas/features/home/domain/entities/dashboard_statistics.dart';
import 'package:hollandkompas/features/home/domain/entities/recent_course.dart';
import 'package:hollandkompas/features/home/domain/entities/recent_student.dart';
import 'package:hollandkompas/features/home/domain/entities/student.dart';
import 'package:hollandkompas/features/home/domain/repositories/admin_dashboard_repository.dart';

class AdminDashboardRepositoryImpl implements AdminDashboardRepository {
  final AdminRemoteDataSource remote;

  AdminDashboardRepositoryImpl(this.remote);

  @override
  Future<DashboardStatistics> getDashboardStatistics() async {
    final students = await remote.getStudentsCount();

    final courses = await remote.getCoursesCount();

    final lessons = await remote.getLessonsCount();

    final enrollments = await remote.getEnrollmentsCount();

    return DashboardStatistics(
      totalStudents: students,
      totalCourses: courses,
      totalLessons: lessons,
      totalEnrollments: enrollments,
    );
  }

  @override
  Future<List<RecentStudent>> getRecentStudents() async {
    return remote.getRecentStudents();
  }

  @override
  Future<List<RecentCourse>> getRecentCourses() async {
    return remote.getRecentCourses();
  }

  @override
  Future<List<Student>> getAllStudents() async {
    return remote.getAllStudents();
  }
}
