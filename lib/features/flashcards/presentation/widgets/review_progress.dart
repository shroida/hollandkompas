import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ReviewProgress extends StatelessWidget {
  const ReviewProgress({super.key, required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : (current / total).clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$current / $total',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              'مراجعة الكلمات',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.subtitleColor(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.mutedColor(context),
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
