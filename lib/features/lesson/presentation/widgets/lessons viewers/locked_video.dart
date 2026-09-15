import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class LockedVideo extends StatelessWidget {
  final VoidCallback onUnlock;

  const LockedVideo({super.key, required this.onUnlock});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.secondary,
                      AppColors.primary.withValues(alpha: 0.75),
                    ],
                  ),
                ),
              ),
            ),

            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'This lesson is locked',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Enroll to unlock all lessons',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                ),

                const SizedBox(height: 18),

                FilledButton.icon(
                  onPressed: onUnlock,
                  icon: const Icon(Icons.school_rounded),
                  label: const Text('Enroll now'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
