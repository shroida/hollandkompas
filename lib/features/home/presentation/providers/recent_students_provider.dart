import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/home/data/providers/admin_dashboard_repository_provider.dart';
import 'package:hollandkompas/features/home/domain/entities/recent_student.dart';

final recentStudentsProvider = FutureProvider<List<RecentStudent>>((ref) async {
  final repository = ref.read(adminDashboardRepositoryProvider);

  return repository.getRecentStudents();
});
