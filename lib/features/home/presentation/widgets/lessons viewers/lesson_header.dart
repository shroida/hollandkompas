import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/home/domain/entities/lesson.dart';
import 'package:hollandkompas/features/home/presentation/widgets/lessons%20viewers/small_badge.dart';

class LessonHeader extends StatelessWidget {
  final Lesson lesson;
  final bool isEnrolled;
  final bool isLocked;

  const LessonHeader({
    super.key,
    required this.lesson,
    required this.isEnrolled,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.14),
                AppColors.secondary.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Icon(
            isLocked ? Icons.lock_rounded : Icons.play_lesson_rounded,
            color: AppColors.primary,
            size: 27,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'LESSON ${lesson.lessonOrder}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.7,
                    ),
                  ),

                  const SizedBox(width: 10),

                  if (!isEnrolled && lesson.lessonOrder == 1)
                    const SmallBadge(text: 'FREE'),

                  if (isLocked) const SmallBadge(text: 'LOCKED'),
                ],
              ),

              const SizedBox(height: 7),

              Text(
                lesson.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 9),

              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 16,
                    color: AppColors.subtitleColor(context),
                  ),

                  const SizedBox(width: 6),

                  Text(
                    '${lesson.durationMinutes} min',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.subtitleColor(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
