import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ReviewProgress extends StatelessWidget {
  const ReviewProgress({super.key, required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : (current / total).clamp(0.0, 1.0);

    final percentage = (progress * 100).round();

    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$current / $total',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Spacer(),
            Text(
              '$percentage%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.subtitleColor(context),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 9,
                backgroundColor: AppColors.mutedColor(context),
                color: AppColors.primary,
              );
            },
          ),
        ),

        const SizedBox(height: 9),

        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            'مراجعة الكلمات',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.subtitleColor(context),
            ),
          ),
        ),
      ],
    );
  }
}
