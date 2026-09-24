import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/localization/app_locale.dart';
import 'package:hollandkompas/core/localization/app_strings.dart';

class ErrorState extends ConsumerWidget {
  final String title;
  final Object? error;
  final VoidCallback onRetry;

  const ErrorState({
    super.key,
    required this.title,
    this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings(ref.watch(appLocaleProvider));
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _ErrorIcon(),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              strings.pleaseTryAgain,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(strings.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorIcon extends StatelessWidget {
  const _ErrorIcon();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.errorContainer,
      ),
      child: Icon(
        Icons.error_outline_rounded,
        size: 30,
        color: colorScheme.onErrorContainer,
      ),
    );
  }
}
