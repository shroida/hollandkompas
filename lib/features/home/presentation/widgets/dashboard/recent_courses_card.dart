import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hollandkompas/features/home/presentation/providers/recent_courses_provider.dart';

class RecentCoursesCard extends ConsumerWidget {
  const RecentCoursesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(recentCoursesProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: courses.when(
          loading: () => const CircularProgressIndicator(),

          error: (e, _) => Text(e.toString()),

          data: (list) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Recent Courses",
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 20),

                ...list.map(
                  (course) => ListTile(
                    title: Text(course.title),
                    subtitle: Text(course.level),
                    trailing: Icon(
                      course.isPublished ? Icons.check_circle : Icons.schedule,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
