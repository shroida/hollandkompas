import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/providers/course_enrollment_provider.dart';
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
        return _EnrollmentDialog(
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

// ═════════════════════════════════════════════════════════════
// COURSE CONTENT
// ═════════════════════════════════════════════════════════════
// ═════════════════════════════════════════════════════════════
// COURSE HEADER
// ═════════════════════════════════════════════════════════════
// ═════════════════════════════════════════════════════════════
// ENROLLMENT BANNER
// ═════════════════════════════════════════════════════════════

// ═════════════════════════════════════════════════════════════
// LESSON CARD
// ═════════════════════════════════════════════════════════════

// ═════════════════════════════════════════════════════════════
// LESSON NUMBER
// ═════════════════════════════════════════════════════════════

// ═════════════════════════════════════════════════════════════
// ENROLLMENT DIALOG
// ═════════════════════════════════════════════════════════════

class _EnrollmentDialog extends StatelessWidget {
  final Course course;
  final Future<void> Function() onEnroll;

  const _EnrollmentDialog({required this.course, required this.onEnroll});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),

      child: Padding(
        padding: const EdgeInsets.all(26),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              width: 76,
              height: 76,

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.secondary, AppColors.primary],
                ),
                borderRadius: BorderRadius.circular(24),
              ),

              child: const Icon(
                Icons.school_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Unlock ${course.title}',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),

            const SizedBox(height: 10),

            Text(
              'You can preview the first lesson for free. '
              'Enroll in this course to unlock all lessons '
              'and track your learning progress.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.subtitleColor(context),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 22),

            const _DialogFeature(
              icon: Icons.lock_open_rounded,
              text: 'Unlock all course lessons',
            ),

            const _DialogFeature(
              icon: Icons.trending_up_rounded,
              text: 'Track your learning progress',
            ),

            const _DialogFeature(
              icon: Icons.school_rounded,
              text: 'Continue your Dutch learning journey',
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,

              child: FilledButton.icon(
                onPressed: () async {
                  await onEnroll();
                },

                icon: const Icon(Icons.school_rounded),

                label: const Text('Enroll now'),

                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 5),

            SizedBox(
              width: double.infinity,

              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },

                child: const Text('Maybe later'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// DIALOG FEATURE
// ═════════════════════════════════════════════════════════════

class _DialogFeature extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DialogFeature({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),

      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,

            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(icon, size: 17, color: AppColors.primary),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),

          const Icon(Icons.check_rounded, size: 18, color: AppColors.primary),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// SECTION HEADER
// ═════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  final int lessonCount;
  final bool isEnrolled;

  const _SectionHeader({required this.lessonCount, required this.isEnrolled});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Course lessons',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),

              const SizedBox(height: 4),

              Text(
                isEnrolled
                    ? 'All lessons are unlocked.'
                    : 'Preview lesson 1 for free.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.subtitleColor(context),
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),

          decoration: BoxDecoration(
            color: AppColors.muted,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Text(
            '$lessonCount lessons',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}

class ErrorState extends StatelessWidget {
  final String title;
  final Object error;
  final VoidCallback onRetry;

  const ErrorState({
    super.key,
    required this.title,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Container(
                width: 72,
                height: 72,

                decoration: BoxDecoration(
                  color: AppColors.destructive.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.cloud_off_rounded,
                  size: 34,
                  color: AppColors.destructive,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Something went wrong. '
                'Please try again.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.subtitleColor(context),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color: AppColors.muted,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Text(
                  error.toString(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.subtitleColor(context),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 19),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
