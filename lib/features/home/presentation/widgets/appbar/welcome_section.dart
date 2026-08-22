import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class WelcomeSection extends StatelessWidget {
  final String firstName;

  const WelcomeSection({super.key, required this.firstName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back 👋',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.subtitleColor(context),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          firstName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 21,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}
