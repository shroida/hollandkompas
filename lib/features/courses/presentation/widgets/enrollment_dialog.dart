import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/localization/app_locale.dart';
import 'package:hollandkompas/core/localization/app_strings.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';

class EnrollmentDialog extends ConsumerWidget {
  final Course course;
  final Future<void> Function() onEnroll;

  const EnrollmentDialog({
    super.key,
    required this.course,
    required this.onEnroll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final strings = AppStrings(locale);
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _EnrollmentIcon(),

            const SizedBox(height: 20),

            Text(
              strings.unlockCourse(course.title),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              strings.previewFirstLessonDescription,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.subtitleColor(context),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 22),

            _DialogFeature(
              icon: Icons.lock_open_rounded,
              text: strings.unlockAllLessons,
            ),

            _DialogFeature(
              icon: Icons.trending_up_rounded,
              text: strings.trackLearningProgress,
            ),

            _DialogFeature(
              icon: Icons.school_rounded,
              text: strings.continueDutchJourney,
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onEnroll,
                icon: const Icon(Icons.school_rounded),
                label: Text(strings.enrollNow),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 5),

            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(strings.maybeLater),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EnrollmentIcon extends StatelessWidget {
  const _EnrollmentIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.secondary, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Icon(Icons.school_rounded, color: Colors.white, size: 36),
    );
  }
}

class _DialogFeature extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DialogFeature({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: AppColors.primary),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const Icon(Icons.check_rounded, size: 18, color: AppColors.primary),
        ],
      ),
    );
  }
}
