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
import 'package:hollandkompas/features/lesson/presentation/providers/lesson_progress_provider.dart';

class CourseLessonsContent extends ConsumerWidget {
  final Course course;
  final List<Lesson> lessons;
  final bool isEnrolled;
  final VoidCallback onEnroll;

  const CourseLessonsContent({
    super.key,
    required this.course,
    required this.lessons,
    required this.isEnrolled,
    required this.onEnroll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings(ref.watch(appLocaleProvider));

    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = _getHorizontalPadding(constraints.maxWidth);
        final totalMinutes = _calculateTotalMinutes();

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
                    course: course,
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
      },
    );
  }

  double _getHorizontalPadding(double width) {
    if (width >= 1000) return 48;
    if (width >= 650) return 32;
    return 20;
  }

  int _calculateTotalMinutes() {
    return lessons.fold(0, (total, lesson) => total + lesson.durationMinutes);
  }
}

class _CourseHeaderSliver extends StatelessWidget {
  final Course course;
  final int lessonsCount;
  final int totalMinutes;
  final bool isEnrolled;
  final double padding;

  const _CourseHeaderSliver({
    required this.course,
    required this.lessonsCount,
    required this.totalMinutes,
    required this.isEnrolled,
    required this.padding,
  });

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
  final Course course;
  final VoidCallback onEnroll;
  final AppStrings strings;
  final double padding;

  const _EnrollmentBannerSliver({
    required this.course,
    required this.onEnroll,
    required this.strings,
    required this.padding,
  });

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
  final int lessonCount;
  final bool isEnrolled;
  final AppStrings strings;
  final double padding;

  const _SectionHeaderSliver({
    required this.lessonCount,
    required this.isEnrolled,
    required this.strings,
    required this.padding,
  });

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
  final List<Lesson> lessons;
  final Course course;
  final bool isEnrolled;
  final VoidCallback onEnroll;
  final double padding;

  const _LessonsListSliver({
    required this.lessons,
    required this.course,
    required this.isEnrolled,
    required this.onEnroll,
    required this.padding,
  });

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
  final Lesson lesson;
  final Course course;
  final List<Lesson> lessons;
  final int index;
  final bool isEnrolled;
  final VoidCallback onEnroll;

  const LessonListItem({
    super.key,
    required this.lesson,
    required this.course,
    required this.lessons,
    required this.index,
    required this.isEnrolled,
    required this.onEnroll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFree = index == 0;
    final isLocked = !isEnrolled && !isFree;
    final completion = ref.watch(lessonCompletionProvider(lesson.id));
    final isCompleted = completion.asData?.value ?? false;
    return LessonCard(
      lesson: lesson,
      isFirst: isFree,
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
  final VoidCallback onEnroll;
  final AppStrings strings;

  const EnrollmentBanner({
    super.key,
    required this.onEnroll,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  strings.tryLearningFree,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  strings.lessonFreeDescription,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.subtitleColor(context),
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

class SectionHeader extends StatelessWidget {
  final int lessonCount;
  final bool isEnrolled;
  final AppStrings strings;

  const SectionHeader({
    super.key,
    required this.lessonCount,
    required this.isEnrolled,
    required this.strings,
  });

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
