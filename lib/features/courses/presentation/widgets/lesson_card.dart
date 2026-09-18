import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/lesson/domain/entities/lesson.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({
    super.key,
    required this.lesson,
    required this.isFirst,
    required this.isLocked,
    required this.isEnrolled,
    required this.isCompleted,
    this.onTap,
  });

  final Lesson lesson;
  final bool isFirst;
  final bool isLocked;
  final bool isEnrolled;
  final bool isCompleted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitleColor = AppColors.subtitleColor(context);

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
                isCompleted: isCompleted,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LessonTitle(
                      title: lesson.title,
                      isFirst: isFirst,
                      isLocked: isLocked,
                      isEnrolled: isEnrolled,
                      isCompleted: isCompleted,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      lesson.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: subtitleColor,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _LessonMetadata(
                      lesson: lesson,
                      subtitleColor: subtitleColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _LessonAction(
                isCompleted: isCompleted,
                isLocked: isLocked,
                subtitleColor: subtitleColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonTitle extends StatelessWidget {
  const _LessonTitle({
    required this.title,
    required this.isFirst,
    required this.isLocked,
    required this.isEnrolled,
    required this.isCompleted,
  });

  final String title;
  final bool isFirst;
  final bool isLocked;
  final bool isEnrolled;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (isCompleted)
          const _LessonBadge(
            text: 'COMPLETED',
            icon: Icons.check_circle_rounded,
            color: AppColors.success,
            backgroundColor: Color(0x1A22C55E),
          )
        else if (isFirst && !isEnrolled)
          const _LessonBadge(
            text: 'FREE',
            icon: Icons.play_circle_rounded,
            color: AppColors.primary,
            backgroundColor: AppColors.accent,
          )
        else if (isLocked)
          _LessonBadge(
            text: 'LOCKED',
            icon: Icons.lock_rounded,
            color: AppColors.mutedForeground,
            backgroundColor: AppColors.muted,
          ),
      ],
    );
  }
}

class _LessonMetadata extends StatelessWidget {
  const _LessonMetadata({required this.lesson, required this.subtitleColor});

  final Lesson lesson;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        const Icon(Icons.schedule_rounded, size: 15, color: AppColors.primary),
        const SizedBox(width: 5),
        Text(
          '${lesson.durationMinutes} min',
          style: textTheme.bodySmall?.copyWith(color: subtitleColor),
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
            style: textTheme.bodySmall?.copyWith(color: subtitleColor),
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
    );
  }
}

class _LessonAction extends StatelessWidget {
  const _LessonAction({
    required this.isCompleted,
    required this.isLocked,
    required this.subtitleColor,
  });

  final bool isCompleted;
  final bool isLocked;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = switch ((isCompleted, isLocked)) {
      (true, _) => AppColors.success.withValues(alpha: 0.12),
      (_, true) => AppColors.muted,
      _ => AppColors.accent,
    };

    final iconColor = switch ((isCompleted, isLocked)) {
      (true, _) => AppColors.success,
      (_, true) => subtitleColor,
      _ => AppColors.primary,
    };

    final icon = switch ((isCompleted, isLocked)) {
      (true, _) => Icons.check_rounded,
      (_, true) => Icons.lock_rounded,
      _ => Icons.arrow_forward_rounded,
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }
}

class _LessonNumber extends StatelessWidget {
  const _LessonNumber({
    required this.number,
    required this.isFirst,
    required this.isLocked,
    required this.isCompleted,
  });

  final int number;
  final bool isFirst;
  final bool isLocked;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final subtitleColor = AppColors.subtitleColor(context);

    final backgroundColor = switch ((isCompleted, isLocked, isFirst)) {
      (true, _, _) => AppColors.success.withValues(alpha: 0.12),
      (_, true, _) => AppColors.muted,
      (_, _, true) => AppColors.primary,
      _ => AppColors.accent,
    };

    final textColor = switch ((isCompleted, isLocked, isFirst)) {
      (true, _, _) => AppColors.success,
      (_, true, _) => subtitleColor,
      (_, _, true) => Colors.white,
      _ => AppColors.primary,
    };

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: switch ((isCompleted, isLocked)) {
        (true, _) => const Icon(
          Icons.check_circle_rounded,
          color: AppColors.success,
          size: 24,
        ),
        (_, true) => Icon(Icons.lock_rounded, color: textColor, size: 20),
        _ => Text(
          number.toString().padLeft(2, '0'),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      },
    );
  }
}

class _LessonBadge extends StatelessWidget {
  const _LessonBadge({
    required this.text,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  final String text;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
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
