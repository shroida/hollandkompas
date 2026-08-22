import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class ContinueLearningCard extends StatelessWidget {
  const ContinueLearningCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.auto_stories_rounded,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keep learning',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Continue your Dutch learning journey.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.subtitleColor(context),
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.check_circle_rounded, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
