import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hollandkompas/features/home/presentation/providers/dashboard_statistics_provider.dart';
import 'statistic_card.dart';

class StatisticsGrid extends ConsumerWidget {
  const StatisticsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statistics = ref.watch(dashboardStatisticsProvider);

    return statistics.when(
      loading: () => const Center(child: CircularProgressIndicator()),

      error: (e, _) => Text(e.toString()),

      data: (stats) {
        return GridView.count(
          crossAxisCount: 2,

          shrinkWrap: true,

          physics: const NeverScrollableScrollPhysics(),

          crossAxisSpacing: 16,

          mainAxisSpacing: 16,

          childAspectRatio: 2,

          children: [
            StatisticCard(
              title: "Students",
              value: stats.totalStudents.toString(),
              icon: Icons.people,
            ),

            StatisticCard(
              title: "Courses",
              value: stats.totalCourses.toString(),
              icon: Icons.menu_book,
            ),

            StatisticCard(
              title: "Lessons",
              value: stats.totalLessons.toString(),
              icon: Icons.play_lesson,
            ),

            StatisticCard(
              title: "Enrollments",
              value: stats.totalEnrollments.toString(),
              icon: Icons.school,
            ),
          ],
        );
      },
    );
  }
}
