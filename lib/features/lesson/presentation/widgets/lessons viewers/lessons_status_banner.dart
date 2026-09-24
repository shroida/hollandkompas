import 'package:flutter/material.dart';

class LessonStatusBanner extends StatelessWidget {
  final int lessonOrder;
  final int totalLessons;
  final bool isEnrolled;
  final bool isLocked;
  final VoidCallback onEnroll;

  const LessonStatusBanner({
    super.key,
    required this.lessonOrder,
    required this.totalLessons,
    required this.isEnrolled,
    required this.isLocked,
    required this.onEnroll,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isEnrolled) {
      return _StatusContainer(
        icon: Icons.check_circle_rounded,
        title: 'You are enrolled',
        subtitle: 'All lessons are available to you.',
        trailing: Icon(Icons.verified_rounded, color: colorScheme.primary),
      );
    }

    if (lessonOrder == 1) {
      return _StatusContainer(
        icon: Icons.play_circle_fill_rounded,
        title: 'Free preview',
        subtitle: 'Lesson 1 is available for free.',
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'FREE',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ),
      );
    }

    return _StatusContainer(
      icon: Icons.lock_rounded,
      title: 'Enrollment required',
      subtitle: 'Enroll to unlock this lesson and the rest of the course.',
      trailing: TextButton(onPressed: onEnroll, child: const Text('Enroll')),
    );
  }
}

class _StatusContainer extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _StatusContainer({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          trailing,
        ],
      ),
    );
  }
}
