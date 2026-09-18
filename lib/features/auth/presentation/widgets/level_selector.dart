import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class LevelSelector extends StatelessWidget {
  const LevelSelector({
    super.key,
    required this.selectedLevel,
    required this.onChanged,
    this.levels = const ['A1', 'A2', 'B1', 'B2'],
  });

  final String selectedLevel;
  final ValueChanged<String> onChanged;
  final List<String> levels;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < levels.length; index++) ...[
          if (index > 0) const SizedBox(width: 8),
          Expanded(
            child: _LevelOption(
              level: levels[index],
              selected: levels[index] == selectedLevel,
              onTap: () => onChanged(levels[index]),
            ),
          ),
        ],
      ],
    );
  }
}

class _LevelOption extends StatelessWidget {
  const _LevelOption({
    required this.level,
    required this.selected,
    required this.onTap,
  });

  final String level;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      height: 48,
      decoration: BoxDecoration(
        color: selected ? AppColors.accent : AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.borderColor(context),
          width: selected ? 1.5 : 1,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.10),
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
          borderRadius: BorderRadius.circular(13),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              style: textTheme.bodyMedium!.copyWith(
                color: selected
                    ? AppColors.primary
                    : AppColors.textColor(context),
                fontWeight: FontWeight.w700,
              ),
              child: Text(level),
            ),
          ),
        ),
      ),
    );
  }
}
