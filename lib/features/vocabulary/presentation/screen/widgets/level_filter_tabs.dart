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
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: levels.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _LevelItem(
              label: 'الكل',
              level: null,
              selected: selected == null,
              onTap: () {
                ref.read(selectedVocabularyLevelProvider.notifier).set(null);
              },
            );
          }

          final level = levels[index - 1];

          return _LevelItem(
            label: _levelLabel(level),
            level: level,
            selected: selected == level,
            onTap: () {
              ref.read(selectedVocabularyLevelProvider.notifier).set(level);
            },
          );
        },
      ),
    );
  }
}

class _LevelItem extends StatelessWidget {
  const _LevelItem({
    required this.label,
    required this.level,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String? level;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _levelColor(level);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.borderColor(context),
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.94,
                      end: 1,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Row(
                key: ValueKey(selected),
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selected) ...[
                    const Icon(
                      Icons.check_rounded,
                      size: 17,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Color _levelColor(String? level) {
  switch (level?.toLowerCase()) {
    case 'a1':
      return AppColors.secondary;

    case 'a2':
      return const Color(0xFF2563EB);

    case 'b1':
      return const Color(0xFF0891B2);

    case 'b2':
      return const Color(0xFF0D9488);

    case 'c1':
      return const Color(0xFF7C3AED);

    case 'c2':
      return const Color(0xFF9333EA);

    default:
      return AppColors.darkBackground;
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
