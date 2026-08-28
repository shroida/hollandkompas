import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class CoursesError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const CoursesError({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: AppColors.destructive,
            ),

            const SizedBox(height: 16),

            Text(
              'Couldn’t load your courses',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 8),

            Text(
              message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.subtitleColor(context),
              ),
            ),

            const SizedBox(height: 18),

            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
