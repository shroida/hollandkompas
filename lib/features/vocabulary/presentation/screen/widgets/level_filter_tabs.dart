import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

import '../../providers/vocabulary_list_providers.dart';

class LevelFilterTabs extends ConsumerWidget {
  const LevelFilterTabs({super.key, required this.levels});

  final List<String> levels;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedVocabularyLevelProvider);

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _buildChip(ref: ref, label: 'الكل', level: null, selected: selected),

          for (final level in levels)
            _buildChip(
              ref: ref,
              label: _levelLabel(level),
              level: level,
              selected: selected,
            ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required WidgetRef ref,
    required String label,
    required String? level,
    required String? selected,
  }) {
    final isSelected = selected == level;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          ref.read(selectedVocabularyLevelProvider.notifier).set(level);
        },
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
}

String _levelLabel(String level) {
  switch (level.toLowerCase()) {
    case 'a1':
      return 'A1';

    case 'a2':
      return 'A2';

    case 'b1':
      return 'B1';

    case 'b2':
      return 'B2';

    case 'c1':
      return 'C1';

    case 'c2':
      return 'C2';

    default:
      return level.toUpperCase();
  }
}
