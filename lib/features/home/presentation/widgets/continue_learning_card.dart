import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/router/route_paths.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/lesson/domain/entities/lesson.dart';

class ContinueLearningCard extends StatelessWidget {
  const ContinueLearningCard({
    super.key,
    required this.course,
    required this.lesson,
    required this.completedLessons,
    required this.totalLessons,
    required this.progress,
    required this.lessons,
    required this.currentIndex,
    required this.isEnrolled,
  });

  final Course course;
  final Lesson lesson;

  final int completedLessons;
  final int totalLessons;

  /// Value between 0.0 and 1.0.
  final double progress;

  final List<Lesson> lessons;
  final int currentIndex;
  final bool isEnrolled;

  @override
  Widget build(BuildContext context) {
    final safeProgress = progress.clamp(0.0, 1.0);
    final percent = (safeProgress * 100).round();

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openLesson(context),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(courseLevel: course.level),
              const SizedBox(height: 18),
              _LessonInfo(lesson: lesson, course: course),
              const SizedBox(height: 20),
              _ProgressSection(
                progress: safeProgress,
                percent: percent,
                completedLessons: completedLessons,
                totalLessons: totalLessons,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _openLesson(context),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Continue learning'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openLesson(BuildContext context) {
    context.push(
      RoutePaths.lessonViewer,
      extra: {
        'course': course,
        'lesson': lesson,
        'lessons': lessons,
        'currentIndex': currentIndex,
        'isEnrolled': isEnrolled,
        'totalLessons': totalLessons,
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.courseLevel});

  final String courseLevel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.secondary, AppColors.primary],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.play_lesson_rounded,
            color: Colors.white,
            size: 23,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Continue Learning',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 3),
              Text(
                'Pick up where you left off',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        _LevelBadge(level: courseLevel),
      ],
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level});

  final String level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        level.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _LessonInfo extends StatelessWidget {
  const _LessonInfo({required this.lesson, required this.course});

  final Lesson lesson;
  final Course course;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          course.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.subtitleColor(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          lesson.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({
    required this.progress,
    required this.percent,
    required this.completedLessons,
    required this.totalLessons,
  });

  final double progress;
  final int percent;
  final int completedLessons;
  final int totalLessons;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Text(
              '$completedLessons / $totalLessons lessons',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.subtitleColor(context),
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '$percent%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.muted,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
