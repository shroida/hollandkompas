import 'package:flutter/material.dart';

class LevelSelector extends StatelessWidget {
  const LevelSelector({
    super.key,
    required this.selectedLevel,
    required this.onChanged,
  });

  final String selectedLevel;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const levels = [
      'A1',
      'A2',
      'B1',
      'B2',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: levels.map((level) {
        final selected =
            selectedLevel == level;

        return ChoiceChip(
          label: Text(level),
          selected: selected,
          onSelected: (_) {
            onChanged(level);
          },
        );
      }).toList(),
    );
  }
}