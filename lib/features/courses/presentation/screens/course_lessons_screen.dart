import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/localization/app_locale.dart';
import 'package:hollandkompas/core/localization/app_strings.dart';
import 'package:hollandkompas/core/shared/widget/error_state.dart';
import 'package:hollandkompas/core/shared/widget/loading_state.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/providers/course_enrollment_provider.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/course_lessons_content.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/course_state_widgets.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/enrollment_dialog.dart';
import 'package:hollandkompas/features/home/presentation/providers/course_lessons_provider.dart';

class CourseLessonsScreen extends ConsumerWidget {
  final Course course;

  const CourseLessonsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings(ref.watch(appLocaleProvider));

    final lessonsAsync = ref.watch(courseLessonsProvider(course.id));

    final enrollmentAsync = ref.watch(courseEnrollmentProvider(course.id));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(
        context: context,
        strings: strings,
        enrollmentAsync: enrollmentAsync,
      ),
      body: _buildBody(
        context: context,
        ref: ref,
        strings: strings,
        lessonsAsync: lessonsAsync,
        enrollmentAsync: enrollmentAsync,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar({
    required BuildContext context,
    required AppStrings strings,
    required AsyncValue<bool> enrollmentAsync,
  }) {
    return AppBar(
      title: Text(strings.courseLessons),
      actions: [
        _EnrollmentAction(
          enrollmentAsync: enrollmentAsync,
          enrollLabel: strings.enroll,
          onEnroll: () => _showEnrollmentDialog(context),
        ),
      ],
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required WidgetRef ref,
    required AppStrings strings,
    required AsyncValue lessonsAsync,
    required AsyncValue<bool> enrollmentAsync,
  }) {
    return lessonsAsync.when(
      loading: () => const LoadingState(),

      error: (error, stackTrace) {
        return ErrorState(
          title: strings.unableToLoadLessons,
          error: error,
          onRetry: () {
            ref.invalidate(courseLessonsProvider(course.id));
          },
        );
      },

      data: (lessons) {
        return enrollmentAsync.when(
          loading: () => const LoadingState(),

          error: (error, stackTrace) {
            return ErrorState(
              title: strings.unableToCheckEnrollment,
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
              onEnroll: () => _showEnrollmentDialog(context),
            );
          },
        );
      },
    );
  }

  Future<void> _showEnrollmentDialog(BuildContext context) async {
    await showDialog<void>(
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

class _EnrollmentAction extends StatelessWidget {
  final AsyncValue<bool> enrollmentAsync;
  final String enrollLabel;
  final VoidCallback onEnroll;

  const _EnrollmentAction({
    required this.enrollmentAsync,
    required this.enrollLabel,
    required this.onEnroll,
  });

  @override
  Widget build(BuildContext context) {
    return enrollmentAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(right: 16),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),

      error: (_, __) => const SizedBox.shrink(),

      data: (isEnrolled) {
        if (isEnrolled) {
          return const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.check_circle_rounded, color: AppColors.primary),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: TextButton.icon(
            onPressed: onEnroll,
            icon: const Icon(Icons.school_rounded, size: 18),
            label: Text(enrollLabel),
          ),
        );
      },
    );
  }
}
