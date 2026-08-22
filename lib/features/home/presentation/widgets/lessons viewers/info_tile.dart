import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const InfoTile({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
                ),

                const SizedBox(height: 2),

                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.subtitleColor(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
