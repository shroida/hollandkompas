import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ReviewButtons extends StatelessWidget {
  const ReviewButtons({
    super.key,
    required this.onRemember,
    required this.onForget,
    required this.enabled,
  });

  final VoidCallback onRemember;
  final VoidCallback onForget;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: enabled ? onForget : null,
            icon: const Icon(Icons.close_rounded),
            label: const Text('نسيت'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.destructive,
              side: BorderSide(
                color: AppColors.destructive.withValues(alpha: 0.4),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: enabled ? onRemember : null,
            icon: const Icon(Icons.check_rounded),
            label: const Text('أتذكر'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
