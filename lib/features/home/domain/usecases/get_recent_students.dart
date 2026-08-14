import 'package:hollandkompas/features/home/domain/entities/recent_student.dart';
import 'package:hollandkompas/features/home/domain/repositories/admin_dashboard_repository.dart';

class GetRecentStudents {
  final AdminDashboardRepository repository;

  const GetRecentStudents(this.repository);

  Future<List<RecentStudent>> call() {
    return repository.getRecentStudents();
  }
}
