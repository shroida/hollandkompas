import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/localization/app_locale.dart';


class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale =
        ref.watch(appLocaleProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: locale.languageCode,
          borderRadius: BorderRadius.circular(16),
          icon: const Icon(Icons.keyboard_arrow_down),
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
              child: Text('🇪🇬 العربية'),
            ),
            DropdownMenuItem(
              value: 'en',
              child: Text('🇺🇸 English'),
            ),
            DropdownMenuItem(
              value: 'nl',
              child: Text('🇳🇱 Nederlands'),
            ),
          ],
        ),
      ),
    );
  }
}