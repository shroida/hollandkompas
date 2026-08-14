import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/home/presentation/widgets/sidebar/dashboard_grid.dart';

import '../../providers/dashboard_statistics_provider.dart';
import '../../providers/recent_courses_provider.dart';
import '../../providers/recent_students_provider.dart';

import '../../widgets/dashboard_grid.dart';
import '../../widgets/dashboard_header.dart';
import '../../widgets/dashboard_loading.dart';
import '../../widgets/recent_courses_card.dart';
import '../../widgets/recent_students_card.dart';

class DesktopAdminDashboard extends ConsumerWidget {
  const DesktopAdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statistics = ref.watch(dashboardStatisticsProvider);

    final students = ref.watch(recentStudentsProvider);

    final courses = ref.watch(recentCoursesProvider);

    return statistics.when(
      loading: () => const DashboardLoading(),

      error: (e, _) => Center(child: Text(e.toString())),

      data: (stats) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const DashboardHeader(),

              const SizedBox(height: 30),

              DashboardGrid(statistics: stats),

              const SizedBox(height: 30),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Expanded(
                    child: students.when(
                      loading: () => const DashboardLoading(),

                      error: (_, __) => const SizedBox(),

                      data: (students) =>
                          RecentStudentsCard(students: students),
                    ),
                  ),

                  const SizedBox(width: 24),

                  Expanded(
                    child: courses.when(
                      loading: () => const DashboardLoading(),

                      error: (_, __) => const SizedBox(),

                      data: (courses) => RecentCoursesCard(courses: courses),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
