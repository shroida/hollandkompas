import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

import '../../../domain/entities/vocabulary_word.dart';
import '../../providers/vocabulary_list_providers.dart';
import 'vocabulary_labels.dart';

class LevelFilterTabs extends ConsumerWidget {
  const LevelFilterTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedVocabularyLevelProvider);

    Widget chip(String label, VocabularyLevel? level) {
      final isSelected = selected == level;
      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) =>
              ref.read(selectedVocabularyLevelProvider.notifier).set(level),
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.foreground,
          ),
          backgroundColor: AppColors.muted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide.none,
          ),
        ),
      );
    }

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          chip('الكل', null),
          for (final level in VocabularyLevel.values) chip(level.label, level),
        ],
      ),
    );
  }
}
