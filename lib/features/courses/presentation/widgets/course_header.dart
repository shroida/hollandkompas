import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';

class CourseHeader extends StatelessWidget {
  final Course course;
  final int lessonCount;
  final int totalMinutes;
  final bool isEnrolled;

  const CourseHeader({
    super.key,
    required this.course,
    required this.lessonCount,
    required this.totalMinutes,
    required this.isEnrolled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondary, Color(0xFF294CA8)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.18),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,

                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(17),
                ),

                child: const Icon(
                  Icons.translate_rounded,
                  color: Colors.white,
                  size: 29,
                ),
              ),

              const SizedBox(width: 14),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),

                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(30),
                ),

                child: Text(
                  course.level.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const Spacer(),

              if (isEnrolled)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: const Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Enrolled',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 24),

          Text(
            course.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            course.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.76),
              height: 1.55,
            ),
          ),

          const SizedBox(height: 25),

          Wrap(
            spacing: 26,
            runSpacing: 14,
            children: [
              _HeaderStat(
                icon: Icons.menu_book_rounded,
                value: '$lessonCount',
                label: 'Lessons',
              ),

              _HeaderStat(
                icon: Icons.schedule_rounded,
                value: '$totalMinutes',
                label: 'Minutes',
              ),

              _HeaderStat(
                icon: Icons.lock_open_rounded,
                value: isEnrolled ? '100%' : '1',
                label: isEnrolled ? 'Unlocked' : 'Free lesson',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _HeaderStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        Container(
          width: 38,
          height: 38,

          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(11),
          ),

          child: Icon(
            icon,
            color: Colors.white.withValues(alpha: 0.9),
            size: 19,
          ),
        ),

        const SizedBox(width: 9),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.65),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
