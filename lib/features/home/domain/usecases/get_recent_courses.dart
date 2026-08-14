import 'package:hollandkompas/features/home/domain/entities/recent_course.dart';
import 'package:hollandkompas/features/home/domain/repositories/admin_dashboard_repository.dart';

class GetRecentCourses {
  final AdminDashboardRepository repository;

  const GetRecentCourses(this.repository);

  Future<List<RecentCourse>> call() {
    return repository.getRecentCourses();
  }
}
