import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

import '../../../domain/entities/vocabulary_stats.dart';

class ProgressSummaryWidget extends StatelessWidget {
  const ProgressSummaryWidget({super.key, required this.stats});

  final VocabularyStats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'نسبة الحفظ',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '${stats.masteredPercentage.toStringAsFixed(0)}%',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: stats.totalWords == 0 ? 0 : stats.masteredPercentage / 100,
            minHeight: 10,
            backgroundColor: AppColors.muted,
            valueColor: const AlwaysStoppedAnimation(AppColors.success),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            _StatTile(
              label: 'محفوظة',
              value: stats.masteredWords,
              color: AppColors.success,
            ),
            const SizedBox(width: 10),
            _StatTile(
              label: 'بتتعلمها',
              value: stats.learningWords,
              color: AppColors.warning,
            ),
            const SizedBox(width: 10),
            _StatTile(
              label: 'جديدة',
              value: stats.newWords,
              color: AppColors.mutedForeground,
            ),
          ],
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardColor(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderColor(context)),
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                color: AppColors.subtitleColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
