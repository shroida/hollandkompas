import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_controller.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/courses_empty.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/courses_error.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/courses_loading.dart';
import 'package:hollandkompas/features/enrollment/presentation/providers/enrolled_courses_provider.dart';
import 'package:hollandkompas/features/home/presentation/providers/published_course_provider.dart';

abstract class StudentCoursesView extends ConsumerWidget {
  const StudentCoursesView({super.key});

  Widget buildContent(
    BuildContext context,
    WidgetRef ref,
    List<Course> courses,
    Set<String> enrolledCourseIds,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(publishedCoursesProvider);
    final authState = ref.watch(authControllerProvider);

    if (authState.isLoading) {
      return const LoadingState();
    }

    final user = authState.user;

    if (user == null) {
      return ErrorState(
        title: 'Error',
        error: 'User not found',
        onRetry: () {
          ref.invalidate(authControllerProvider);
          ref.invalidate(publishedCoursesProvider);
        },
      );
    }

    final enrolledCoursesAsync = ref.watch(enrolledCoursesProvider(user.id));

    return coursesAsync.when(
      loading: () => const LoadingState(),
      error: (error, _) => ErrorState(
        title: 'Error',
        error: error,
        onRetry: () {
          ref.invalidate(publishedCoursesProvider);
          ref.invalidate(enrolledCoursesProvider(user.id));
        },
      ),
      data: (courses) {
        if (courses.isEmpty) {
          return const EmptyCourses();
        }

        return enrolledCoursesAsync.when(
          loading: () => const LoadingState(),
          error: (error, _) => ErrorState(
            title: 'Error',
            error: error,
            onRetry: () {
              ref.invalidate(enrolledCoursesProvider(user.id));
            },
          ),
          data: (enrolledCourses) {
            final enrolledCourseIds = enrolledCourses
                .map((enrollment) => enrollment.course.id)
                .toSet();

            return buildContent(context, ref, courses, enrolledCourseIds);
          },
        );
      },
    );
  }
}
