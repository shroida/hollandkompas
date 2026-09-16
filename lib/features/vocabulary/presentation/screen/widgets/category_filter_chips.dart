import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

import '../../../domain/entities/vocabulary_word.dart';
import '../../providers/vocabulary_list_providers.dart';
import 'vocabulary_labels.dart';

class CategoryFilterChips extends ConsumerWidget {
  const CategoryFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedVocabularyCategoryProvider);

    Widget chip(String label, IconData? icon, VocabularyCategory? category) {
      final isSelected = selected == category;
      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: FilterChip(
          avatar: icon == null
              ? null
              : Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.primary),
          label: Text(label),
          selected: isSelected,
          onSelected: (_) => ref
              .read(selectedVocabularyCategoryProvider.notifier)
              .set(category),
          selectedColor: AppColors.secondary,
          backgroundColor: AppColors.muted,
          labelStyle: TextStyle(
            fontFamily: 'Cairo',
            color: isSelected ? Colors.white : AppColors.foreground,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide.none,
          ),
        ),
      );
    }

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          chip('كل الموضوعات', null, null),
          for (final category in VocabularyCategory.values)
            chip(category.labelAr, category.icon, category),
        ],
      ),
    );
  }
}
