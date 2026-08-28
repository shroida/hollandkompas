import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/providers/course_enrollment_provider.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/course_header.dart';
import 'package:hollandkompas/features/home/domain/entities/lesson.dart';
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
              return _CourseLessonsContent(
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

class _CourseLessonsContent extends StatelessWidget {
  final Course course;
  final List<Lesson> lessons;
  final bool isEnrolled;
  final VoidCallback onEnroll;

  const _CourseLessonsContent({
    required this.course,
    required this.lessons,
    required this.isEnrolled,
    required this.onEnroll,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1000;
        final isTablet = constraints.maxWidth >= 650;

        final horizontalPadding = isDesktop
            ? 48.0
            : isTablet
            ? 32.0
            : 20.0;

        final totalMinutes = lessons.fold<int>(
          0,
          (sum, lesson) => sum + lesson.durationMinutes,
        );

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // COURSE HEADER
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    24,
                    horizontalPadding,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: CourseHeader(
                      course: course,
                      lessonCount: lessons.length,
                      totalMinutes: totalMinutes,
                      isEnrolled: isEnrolled,
                    ),
                  ),
                ),

                // ENROLLMENT BANNER
                if (!isEnrolled)
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      18,
                      horizontalPadding,
                      0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _EnrollmentBanner(
                        course: course,
                        onEnroll: onEnroll,
                      ),
                    ),
                  ),

                // SECTION HEADER
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    32,
                    horizontalPadding,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _SectionHeader(
                      lessonCount: lessons.length,
                      isEnrolled: isEnrolled,
                    ),
                  ),
                ),

                // LESSONS
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    16,
                    horizontalPadding,
                    40,
                  ),
                  sliver: SliverList.builder(
                    itemCount: lessons.length,

                    itemBuilder: (context, index) {
                      final lesson = lessons[index];

                      // Lesson 1 is free.
                      final isFree = index == 0;

                      // If enrolled -> NOTHING is locked.
                      // If not enrolled -> only lesson 1 is open.
                      final isLocked = !isEnrolled && !isFree;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: LessonCard(
                          lesson: lesson,
                          isFirst: isFree,
                          isLocked: isLocked,
                          isEnrolled: isEnrolled,

                          onTap: () {
                            if (isLocked) {
                              onEnroll();
                              return;
                            }

                            context.push(
                              '/lesson-viewer',
                              extra: {
                                'lesson': lesson,
                                'isEnrolled': isEnrolled,
                                'totalLessons': lessons.length,
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ═════════════════════════════════════════════════════════════
// COURSE HEADER
// ═════════════════════════════════════════════════════════════
// ═════════════════════════════════════════════════════════════
// ENROLLMENT BANNER
// ═════════════════════════════════════════════════════════════

class _EnrollmentBanner extends StatelessWidget {
  final Course course;
  final VoidCallback onEnroll;

  const _EnrollmentBanner({required this.course, required this.onEnroll});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.10)),
      ),

      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),

            child: const Icon(Icons.school_rounded, color: AppColors.primary),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start learning for free',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),

                const SizedBox(height: 4),

                Text(
                  'Lesson 1 is free. Enroll to unlock the entire course.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.subtitleColor(context),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          FilledButton(onPressed: onEnroll, child: const Text('Enroll')),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// LESSON CARD
// ═════════════════════════════════════════════════════════════

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final bool isFirst;
  final bool isLocked;
  final bool isEnrolled;
  final VoidCallback? onTap;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.isFirst,
    required this.isLocked,
    required this.isEnrolled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),

        child: Padding(
          padding: const EdgeInsets.all(17),

          child: Row(
            children: [
              _LessonNumber(
                number: lesson.lessonOrder,
                isFirst: isFirst,
                isLocked: isLocked,
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            lesson.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        if (isFirst && !isEnrolled)
                          const _LessonBadge(
                            text: 'FREE',
                            icon: Icons.play_circle_rounded,
                          ),

                        if (isLocked)
                          const _LessonBadge(
                            text: 'LOCKED',
                            icon: Icons.lock_rounded,
                            isLocked: true,
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      lesson.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.subtitleColor(context),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 15,
                          color: AppColors.primary,
                        ),

                        const SizedBox(width: 5),

                        Text(
                          '${lesson.durationMinutes} min',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.subtitleColor(context),
                          ),
                        ),

                        if (lesson.videoUrl != null) ...[
                          const SizedBox(width: 14),

                          const Icon(
                            Icons.play_circle_outline_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            'Video',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.subtitleColor(context),
                            ),
                          ),
                        ],

                        if (lesson.audioUrl != null) ...[
                          const SizedBox(width: 14),

                          const Icon(
                            Icons.headphones_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              AnimatedContainer(
                duration: const Duration(milliseconds: 200),

                width: 44,
                height: 44,

                decoration: BoxDecoration(
                  color: isLocked ? AppColors.muted : AppColors.accent,
                  borderRadius: BorderRadius.circular(14),
                ),

                child: Icon(
                  isLocked ? Icons.lock_rounded : Icons.arrow_forward_rounded,
                  color: isLocked
                      ? AppColors.subtitleColor(context)
                      : AppColors.primary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// LESSON NUMBER
// ═════════════════════════════════════════════════════════════

class _LessonNumber extends StatelessWidget {
  final int number;
  final bool isFirst;
  final bool isLocked;

  const _LessonNumber({
    required this.number,
    required this.isFirst,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isLocked
        ? AppColors.muted
        : isFirst
        ? AppColors.primary
        : AppColors.accent;

    final textColor = isLocked
        ? AppColors.subtitleColor(context)
        : isFirst
        ? Colors.white
        : AppColors.primary;

    return Container(
      width: 50,
      height: 50,

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Center(
        child: isLocked
            ? Icon(Icons.lock_rounded, color: textColor, size: 20)
            : Text(
                number.toString().padLeft(2, '0'),
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// LESSON BADGE
// ═════════════════════════════════════════════════════════════

class _LessonBadge extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isLocked;

  const _LessonBadge({
    required this.text,
    required this.icon,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isLocked
        ? AppColors.subtitleColor(context)
        : AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),

      decoration: BoxDecoration(
        color: isLocked ? AppColors.muted : AppColors.accent,
        borderRadius: BorderRadius.circular(8),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),

          const SizedBox(width: 4),

          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

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
