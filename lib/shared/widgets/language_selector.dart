import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_locale.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final locale = ref.watch(appLocaleProvider);

    return DropdownButton<String>(
      value: locale.languageCode,
      underline: const SizedBox(),
      items: const [
        DropdownMenuItem(
          value: 'ar',
          child: Text('🇪🇬 العربية'),
        ),
        DropdownMenuItem(
          value: 'nl',
          child: Text('🇳🇱 Nederlands'),
        ),
        DropdownMenuItem(
          value: 'en',
          child: Text('🇺🇸 English'),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          ref
              .read(appLocaleProvider.notifier)
              .changeLanguage(value);
        }
      },
    );
  }
}