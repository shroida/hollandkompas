import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class FreeLessonCard extends StatelessWidget {
  final VoidCallback onEnroll;

  const FreeLessonCard({super.key, required this.onEnroll});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondary, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.school_rounded, color: Colors.white, size: 30),

          const SizedBox(height: 14),

          const Text(
            'Enjoying the lesson?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'Enroll in this course to unlock all lessons, '
            'track your progress, and continue learning.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onEnroll,
              icon: const Icon(Icons.school_rounded),
              label: const Text('Enroll in this course'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
