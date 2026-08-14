import 'package:hollandkompas/features/home/data/datasource/admin_remote_data_source.dart';

class AdminDashboardRepositoryImpl implements AdminDashboardRepository {
  final AdminRemoteDataSource remote;

  AdminDashboardRepositoryImpl(this.remote);

  @override
  Future<DashboardStatistics> getStatistics() async {
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
}
