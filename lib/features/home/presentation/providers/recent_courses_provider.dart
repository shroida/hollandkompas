import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'admin_dashboard_repository_provider.dart';

import 'package:hollandkompas/features/home/domain/entities/recent_course.dart';
import 'package:hollandkompas/features/home/domain/usecases/get_recent_courses.dart';

final recentCoursesProvider = FutureProvider<List<RecentCourse>>((ref) async {
  final useCase = GetRecentCourses(ref.read(adminDashboardRepositoryProvider));

  return useCase();
});
