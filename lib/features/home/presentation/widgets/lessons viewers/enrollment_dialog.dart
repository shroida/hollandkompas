import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class EnrollmentDialog extends StatelessWidget {
  final VoidCallback onEnroll;

  const EnrollmentDialog({super.key, required this.onEnroll});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),

      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 12),

      title: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_open_rounded,
              color: AppColors.primary,
              size: 32,
            ),
          ),

          const SizedBox(height: 18),

          const Text('Unlock this course', textAlign: TextAlign.center),
        ],
      ),

      content: const Text(
        'This lesson is available after enrollment. '
        'Enroll now to unlock all lessons and track your progress.',
        textAlign: TextAlign.center,
      ),

      actionsPadding: const EdgeInsets.fromLTRB(20, 8, 20, 20),

      actions: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onEnroll,
            icon: const Icon(Icons.school_rounded),
            label: const Text('Enroll now'),
          ),
        ),

        const SizedBox(height: 6),

        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Maybe later'),
          ),
        ),
      ],
    );
  }
}
