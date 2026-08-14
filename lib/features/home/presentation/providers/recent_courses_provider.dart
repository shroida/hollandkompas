import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'admin_dashboard_repository_provider.dart';

import 'package:hollandkompas/features/home/domain/entities/recent_student.dart';
import 'package:hollandkompas/features/home/domain/usecases/get_recent_students.dart';

final recentStudentsProvider = FutureProvider<List<RecentStudent>>((ref) async {
  final useCase = GetRecentStudents(ref.read(adminDashboardRepositoryProvider));

  return useCase();
});
