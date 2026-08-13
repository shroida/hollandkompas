import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/localization/app_locale.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);

    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: locale.languageCode,
          isDense: true,
          iconSize: 18,
          borderRadius: BorderRadius.circular(12),
          style: Theme.of(context).textTheme.bodySmall,
          icon: const Icon(Icons.language, size: 18),
          onChanged: (value) {
            if (value != null) {
              ref
                  .read(appLocaleProvider.notifier)
                  .changeLanguage(value);
            }
          },
          items: const [
            DropdownMenuItem(
              value: 'ar',
              child: Text('🇪🇬'),
            ),
            DropdownMenuItem(
              value: 'en',
              child: Text('🇺🇸'),
            ),
            DropdownMenuItem(
              value: 'nl',
              child: Text('🇳🇱'),
            ),
          ],
        ),
      ),
    );
  }
}