import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/providers/course_enrollment_provider.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/course_lessons_content.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/enrollment_dialog.dart';
import 'package:hollandkompas/features/home/presentation/providers/course_lessons_provider.dart';

class CourseLessonsScreen extends ConsumerWidget {
  final Course course;
  final bool isEnrolled;

  const CourseLessonsScreen({
    super.key,
    required this.course,
    required this.isEnrolled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(courseLessonsProvider(course.id));

    final enrollmentAsync = ref.watch(courseEnrollmentProvider(course.id));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text('Course'),

        actions: [
          enrollmentAsync.when(
            loading: () {
              return const Padding(
                padding: EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },

            error: (error, stackTrace) {
              return const SizedBox.shrink();
            },

            data: (isEnrolled) {
              if (isEnrolled) {
                return const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primary,
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: TextButton.icon(
                  onPressed: () {
                    _showEnrollmentDialog(context);
                  },
                  icon: const Icon(Icons.school_rounded, size: 18),
                  label: const Text('Enroll'),
                ),
              );
            },
          ),
        ],
      ),

      body: lessonsAsync.when(
        loading: () {
          return const LoadingState();
        },

        error: (error, stackTrace) {
          return ErrorState(
            title: 'Unable to load lessons',
            error: error,
            onRetry: () {
              ref.invalidate(courseLessonsProvider(course.id));
            },
          );
        },

        data: (lessons) {
          return enrollmentAsync.when(
            loading: () {
              return const LoadingState();
            },

            error: (error, stackTrace) {
              return ErrorState(
                title: 'Unable to check enrollment',
                error: error,
                onRetry: () {
                  ref.invalidate(courseEnrollmentProvider(course.id));
                },
              );
            },

            data: (isEnrolled) {
              return CourseLessonsContent(
                course: course,
                lessons: lessons,
                isEnrolled: isEnrolled,

                onEnroll: () {
                  _showEnrollmentDialog(context);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showEnrollmentDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return EnrollmentDialog(
          course: course,
          onEnroll: () async {
            Navigator.of(context).pop();

            await context.push('/payment', extra: {'course': course});
          },
        );
      },
    );
  }
}
