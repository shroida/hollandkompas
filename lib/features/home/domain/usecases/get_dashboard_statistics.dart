import 'package:hollandkompas/features/home/domain/entities/dashboard_statistics.dart';
import 'package:hollandkompas/features/home/domain/repositories/admin_dashboard_repository.dart';

class GetDashboardStatistics {
  final AdminDashboardRepository repository;

  const GetDashboardStatistics(this.repository);

  Future<DashboardStatistics> call() {
    return repository.getDashboardStatistics();
  }
}
