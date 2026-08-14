import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hollandkompas/features/home/presentation/providers/recent_students_provider.dart';

class RecentStudentsCard extends ConsumerWidget {
  const RecentStudentsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(recentStudentsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: students.when(
          loading: () => const CircularProgressIndicator(),

          error: (e, _) => Text(e.toString()),

          data: (list) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Recent Students",
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 20),

                ...list.map(
                  (student) => ListTile(
                    title: Text(student.fullName),
                    subtitle: Text(student.email),
                    trailing: Text(student.level),
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
