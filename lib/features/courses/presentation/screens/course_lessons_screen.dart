import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/localization/app_locale.dart';
import 'package:hollandkompas/core/localization/app_strings.dart';
import 'package:hollandkompas/core/router/route_paths.dart';
import 'package:hollandkompas/core/shared/widget/error_state.dart';
import 'package:hollandkompas/core/shared/widget/loading_state.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/providers/course_enrollment_provider.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/course_lessons_content.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/enrollment_dialog.dart';
import 'package:hollandkompas/features/home/presentation/providers/course_lessons_provider.dart';

class CourseLessonsScreen extends ConsumerWidget {
  const CourseLessonsScreen({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final strings = AppStrings(locale);
    final lessonsAsync = ref.watch(courseLessonsProvider(course.id));
    final enrollmentAsync = ref.watch(courseEnrollmentProvider(course.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.courseLessons),
        actions: [
          _EnrollmentAction(
            enrollmentAsync: enrollmentAsync,
            enrollLabel: strings.enroll,
            onEnroll: () => _showEnrollmentDialog(context),
          ),
        ],
      ),
      body: _CourseLessonsBody(
        course: course,
        strings: strings,
        lessonsAsync: lessonsAsync,
        enrollmentAsync: enrollmentAsync,
        onRetryLessons: () {
          ref.invalidate(courseLessonsProvider(course.id));
        },
        onRetryEnrollment: () {
          ref.invalidate(courseEnrollmentProvider(course.id));
        },
        onEnroll: () => _showEnrollmentDialog(context),
      ),
    );
  }

  Future<void> _showEnrollmentDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => EnrollmentDialog(
        course: course,
        onEnroll: () async {
          Navigator.of(context).pop();
          await context.push(RoutePaths.payment, extra: course);
        },
      ),
    );
  }
}

class _CourseLessonsBody extends StatelessWidget {
  const _CourseLessonsBody({
    required this.course,
    required this.strings,
    required this.lessonsAsync,
    required this.enrollmentAsync,
    required this.onRetryLessons,
    required this.onRetryEnrollment,
    required this.onEnroll,
  });

  final Course course;
  final AppStrings strings;
  final AsyncValue lessonsAsync;
  final AsyncValue<bool> enrollmentAsync;
  final VoidCallback onRetryLessons;
  final VoidCallback onRetryEnrollment;
  final VoidCallback onEnroll;

  @override
  Widget build(BuildContext context) {
    return lessonsAsync.when(
      loading: () => const LoadingState(),
      error: (error, _) => ErrorState(
        title: strings.unableToLoadLessons,
        error: error,
        onRetry: onRetryLessons,
      ),
      data: (lessons) => enrollmentAsync.when(
        loading: () => const LoadingState(),
        error: (error, _) => ErrorState(
          title: strings.unableToCheckEnrollment,
          error: error,
          onRetry: onRetryEnrollment,
        ),
        data: (isEnrolled) => CourseLessonsContent(
          course: course,
          lessons: lessons,
          isEnrolled: isEnrolled,
          onEnroll: onEnroll,
        ),
      ),
    );
  }
}

class _EnrollmentAction extends StatelessWidget {
  const _EnrollmentAction({
    required this.enrollmentAsync,
    required this.enrollLabel,
    required this.onEnroll,
  });

  final AsyncValue<bool> enrollmentAsync;
  final String enrollLabel;
  final VoidCallback onEnroll;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return enrollmentAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(right: 16),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (isEnrolled) => isEnrolled
          ? Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.check_circle_rounded,
                color: colorScheme.primary,
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton.icon(
                onPressed: onEnroll,
                icon: const Icon(Icons.school_rounded, size: 18),
                label: Text(enrollLabel),
              ),
            ),
    );
  }
}
