import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

import '../../../domain/entities/vocabulary_word.dart';
import '../../providers/vocabulary_user_providers.dart';
import 'pronunciation_button.dart';
import 'vocabulary_labels.dart';

class WordCard extends ConsumerWidget {
  const WordCard({super.key, required this.word, required this.onTap});

  final VocabularyWord word;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              _LevelBadge(level: word.level),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      word.dutchWord,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      word.arabicMeaning,
                      textDirection: TextDirection.rtl,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.subtitleColor(context),
                          ),
                    ),
                  ],
                ),
              ),
              PronunciationButton(text: word.dutchWord, size: 20),
              IconButton(
                tooltip: 'حفظ الكلمة',
                onPressed: () => ref
                    .read(vocabularyActionsProvider.notifier)
                    .toggleFavorite(word.id, !word.isFavorite),
                icon: Icon(
                  word.isFavorite ? Icons.bookmark : Icons.bookmark_border,
                  color: word.isFavorite ? AppColors.primary : AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level});

  final VocabularyLevel level;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        level.label,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
