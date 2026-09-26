import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/flashcard.dart';

class FlashcardView extends StatefulWidget {
  const FlashcardView({super.key, required this.card, required this.onSpeak});

  final Flashcard card;
  final VoidCallback onSpeak;

  @override
  State<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView> {
  bool _showAnswer = false;

  void _flip() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  @override
  void didUpdateWidget(covariant FlashcardView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.card.id != widget.card.id) {
      _showAnswer = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _flip,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Container(
          key: ValueKey(_showAnswer),
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 360),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.cardColor(context),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.borderColor(context)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _showAnswer ? 'المعنى' : 'الكلمة الهولندية',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.subtitleColor(context),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                _showAnswer ? widget.card.arabicMeaning : widget.card.dutchWord,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: _showAnswer ? AppColors.secondary : AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (!_showAnswer) ...[
                const SizedBox(height: 28),
                IconButton.filled(
                  onPressed: widget.onSpeak,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.accentColor(context),
                    foregroundColor: AppColors.primary,
                  ),
                  icon: const Icon(Icons.volume_up_rounded),
                ),
              ],
              const SizedBox(height: 30),
              Text(
                _showAnswer ? 'اضغط للعودة إلى الكلمة' : 'اضغط لإظهار المعنى',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.subtitleColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
