import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hollandkompas/features/home/data/datasource/admin_remote_data_source.dart';
import 'package:hollandkompas/features/home/data/datasource/admin_remote_data_source_impl.dart';
import 'package:hollandkompas/features/home/data/repositories/admin_dashboard_repository_impl.dart';
import 'package:hollandkompas/features/home/domain/repositories/admin_dashboard_repository.dart';

final adminRemoteDataSourceProvider = Provider<AdminRemoteDataSource>((ref) {
  return AdminRemoteDataSourceImpl();
});

final adminDashboardRepositoryProvider = Provider<AdminDashboardRepository>((
  ref,
) {
  return AdminDashboardRepositoryImpl(ref.read(adminRemoteDataSourceProvider));
});
