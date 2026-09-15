import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class LessonDescription extends StatelessWidget {
  final String description;

  const LessonDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About this lesson',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 10),

            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.subtitleColor(context),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
