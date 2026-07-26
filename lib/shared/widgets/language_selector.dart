import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(16),
        color:
            Theme.of(context).colorScheme.surface,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: 'ar',
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
          onChanged: (_) {},
        ),
      ),
    );
  }
}