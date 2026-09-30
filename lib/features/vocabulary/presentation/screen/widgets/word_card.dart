import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

import '../../../domain/entities/vocabulary_word.dart';
import '../../providers/vocabulary_user_providers.dart';
import 'pronunciation_button.dart';

class WordCard extends ConsumerStatefulWidget {
  const WordCard({super.key, required this.word, required this.onTap});

  final VocabularyWord word;
  final VoidCallback onTap;

  @override
  ConsumerState<WordCard> createState() => _WordCardState();
}

class _WordCardState extends ConsumerState<WordCard> {
  late bool _isFavorite;
  bool _isUpdatingFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.word.isFavorite;
  }

  @override
  void didUpdateWidget(covariant WordCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.word.isFavorite != widget.word.isFavorite) {
      _isFavorite = widget.word.isFavorite;
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isUpdatingFavorite) {
      return;
    }

    final previousValue = _isFavorite;
    final newValue = !previousValue;

    setState(() {
      _isFavorite = newValue;
      _isUpdatingFavorite = true;
    });

    try {
      await ref
          .read(vocabularyActionsProvider.notifier)
          .toggleFavorite(widget.word.id, newValue);

      if (!mounted) {
        return;
      }

      ref.invalidate(favoriteVocabularyWordsProvider);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isFavorite = previousValue;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تعذر ${newValue ? 'حفظ' : 'إزالة'} الكلمة. حاول مرة أخرى.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingFavorite = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              _LevelBadge(level: widget.word.level),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.word.dutchWord,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.word.arabicMeaning,
                      textDirection: TextDirection.rtl,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.subtitleColor(context),
                      ),
                    ),
                  ],
                ),
              ),

              PronunciationButton(text: widget.word.dutchWord, size: 20),

              IconButton(
                tooltip: _isFavorite ? 'إزالة من المحفوظات' : 'حفظ الكلمة',
                onPressed: _isUpdatingFavorite ? null : _toggleFavorite,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: _isUpdatingFavorite
                      ? const SizedBox(
                          key: ValueKey('loading'),
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        )
                      : Icon(
                          _isFavorite ? Icons.bookmark : Icons.bookmark_border,
                          key: ValueKey(_isFavorite),
                          color: _isFavorite
                              ? AppColors.primary
                              : AppColors.mutedForeground,
                        ),
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

  final String level;

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
        level.toUpperCase(),
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
