import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/courses_empty.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/courses_error.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/courses_loading.dart';
import 'package:hollandkompas/features/home/presentation/providers/published_course_provider.dart';

abstract class StudentCoursesView extends ConsumerWidget {
  const StudentCoursesView({super.key});

  Widget buildContent(
    BuildContext context,
    WidgetRef ref,
    List<Course> courses,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(publishedCoursesProvider);

    return coursesAsync.when(
      loading: () => const CoursesLoading(),

      error: (error, _) {
        return CoursesError(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(publishedCoursesProvider);
          },
        );
      },

      data: (courses) {
        if (courses.isEmpty) {
          return const EmptyCourses();
        }

        return buildContent(context, ref, courses);
      },
    );
  }
}
