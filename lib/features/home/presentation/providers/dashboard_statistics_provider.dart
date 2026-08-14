import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'admin_dashboard_repository_provider.dart';

import 'package:hollandkompas/features/home/domain/entities/dashboard_statistics.dart';
import 'package:hollandkompas/features/home/domain/usecases/get_dashboard_statistics.dart';

final dashboardStatisticsProvider = FutureProvider<DashboardStatistics>((
  ref,
) async {
  final useCase = GetDashboardStatistics(
    ref.read(adminDashboardRepositoryProvider),
  );

  return useCase();
});
