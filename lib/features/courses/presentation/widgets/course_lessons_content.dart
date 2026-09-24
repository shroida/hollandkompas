import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/localization/app_locale.dart';
import 'package:hollandkompas/core/localization/app_strings.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/course_header.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/lesson_card.dart';
import 'package:hollandkompas/features/lesson/domain/entities/lesson.dart';
import 'package:hollandkompas/features/lesson/presentation/providers/lesson_completion_provider.dart';

class CourseLessonsContent extends ConsumerWidget {
  const CourseLessonsContent({
    super.key,
    required this.course,
    required this.lessons,
    required this.isEnrolled,
    required this.onEnroll,
  });

  final Course course;
  final List<Lesson> lessons;
  final bool isEnrolled;
  final VoidCallback onEnroll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings(ref.watch(appLocaleProvider));
    final padding = _horizontalPadding(MediaQuery.sizeOf(context).width);
    final totalMinutes = _totalMinutes;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _CourseHeaderSliver(
              course: course,
              lessonsCount: lessons.length,
              totalMinutes: totalMinutes,
              isEnrolled: isEnrolled,
              padding: padding,
            ),
            if (!isEnrolled)
              _EnrollmentBannerSliver(
                onEnroll: onEnroll,
                strings: strings,
                padding: padding,
              ),
            _SectionHeaderSliver(
              lessonCount: lessons.length,
              isEnrolled: isEnrolled,
              strings: strings,
              padding: padding,
            ),
            _LessonsListSliver(
              lessons: lessons,
              course: course,
              isEnrolled: isEnrolled,
              onEnroll: onEnroll,
              padding: padding,
            ),
          ],
        ),
      ),
    );
  }

  int get _totalMinutes {
    return lessons.fold(0, (total, lesson) => total + lesson.durationMinutes);
  }

  static double _horizontalPadding(double width) {
    if (width >= 1000) return 48;
    if (width >= 650) return 32;
    return 20;
  }
}

class _CourseHeaderSliver extends StatelessWidget {
  const _CourseHeaderSliver({
    required this.course,
    required this.lessonsCount,
    required this.totalMinutes,
    required this.isEnrolled,
    required this.padding,
  });

  final Course course;
  final int lessonsCount;
  final int totalMinutes;
  final bool isEnrolled;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(padding, 24, padding, 0),
      sliver: SliverToBoxAdapter(
        child: CourseHeader(
          course: course,
          lessonCount: lessonsCount,
          totalMinutes: totalMinutes,
          isEnrolled: isEnrolled,
        ),
      ),
    );
  }
}

class _EnrollmentBannerSliver extends StatelessWidget {
  const _EnrollmentBannerSliver({
    required this.onEnroll,
    required this.strings,
    required this.padding,
  });

  final VoidCallback onEnroll;
  final AppStrings strings;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(padding, 18, padding, 0),
      sliver: SliverToBoxAdapter(
        child: EnrollmentBanner(onEnroll: onEnroll, strings: strings),
      ),
    );
  }
}

class _SectionHeaderSliver extends StatelessWidget {
  const _SectionHeaderSliver({
    required this.lessonCount,
    required this.isEnrolled,
    required this.strings,
    required this.padding,
  });

  final int lessonCount;
  final bool isEnrolled;
  final AppStrings strings;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(padding, 32, padding, 0),
      sliver: SliverToBoxAdapter(
        child: SectionHeader(
          lessonCount: lessonCount,
          isEnrolled: isEnrolled,
          strings: strings,
        ),
      ),
    );
  }
}

class _LessonsListSliver extends StatelessWidget {
  const _LessonsListSliver({
    required this.lessons,
    required this.course,
    required this.isEnrolled,
    required this.onEnroll,
    required this.padding,
  });

  final List<Lesson> lessons;
  final Course course;
  final bool isEnrolled;
  final VoidCallback onEnroll;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(padding, 16, padding, 40),
      sliver: SliverList.builder(
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: LessonListItem(
              lesson: lessons[index],
              course: course,
              lessons: lessons,
              index: index,
              isEnrolled: isEnrolled,
              onEnroll: onEnroll,
            ),
          );
        },
      ),
    );
  }
}

class LessonListItem extends ConsumerWidget {
  const LessonListItem({
    super.key,
    required this.lesson,
    required this.course,
    required this.lessons,
    required this.index,
    required this.isEnrolled,
    required this.onEnroll,
  });

  final Lesson lesson;
  final Course course;
  final List<Lesson> lessons;
  final int index;
  final bool isEnrolled;
  final VoidCallback onEnroll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFirst = index == 0;
    final isLocked = !isEnrolled && !isFirst;
    final completion = ref.watch(lessonCompletionProvider(lesson.id));
    final isCompleted = completion.asData?.value ?? false;

    return LessonCard(
      lesson: lesson,
      isFirst: isFirst,
      isLocked: isLocked,
      isEnrolled: isEnrolled,
      isCompleted: isCompleted,
      onTap: () => _openLesson(context, ref, isLocked),
    );
  }

  Future<void> _openLesson(
    BuildContext context,
    WidgetRef ref,
    bool isLocked,
  ) async {
    if (isLocked) {
      onEnroll();
      return;
    }

    await context.push(
      '/lesson-viewer',
      extra: {
        'course': course,
        'lesson': lesson,
        'lessons': lessons,
        'currentIndex': index,
        'isEnrolled': isEnrolled,
        'totalLessons': lessons.length,
      },
    );

    if (!context.mounted) return;

    ref.invalidate(lessonCompletionProvider(lesson.id));
  }
}

class EnrollmentBanner extends StatelessWidget {
  const EnrollmentBanner({
    super.key,
    required this.onEnroll,
    required this.strings,
  });

  final VoidCallback onEnroll;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitleColor = AppColors.subtitleColor(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          const _EnrollmentBannerIcon(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.tryLearningFree,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  strings.lessonFreeDescription,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: subtitleColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(onPressed: onEnroll, child: Text(strings.enroll)),
        ],
      ),
    );
  }
}

class _EnrollmentBannerIcon extends StatelessWidget {
  const _EnrollmentBannerIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(Icons.school_rounded, color: AppColors.primary),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.lessonCount,
    required this.isEnrolled,
    required this.strings,
  });

  final int lessonCount;
  final bool isEnrolled;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.courseLessons,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isEnrolled
                    ? strings.allLessonsUnlocked
                    : strings.previewLessonFree,
                style: theme.textTheme.bodySmall?.copyWith(
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
            strings.lessonsCount(lessonCount),
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
