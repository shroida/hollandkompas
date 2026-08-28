import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/home/domain/entities/lesson.dart';

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
