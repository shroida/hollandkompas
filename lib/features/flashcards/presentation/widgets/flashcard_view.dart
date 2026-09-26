import 'dart:math' as math;

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

class _FlashcardViewState extends State<FlashcardView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_showAnswer) {
      _controller.reverse();
    } else {
      _controller.forward();
    }

    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  @override
  void didUpdateWidget(covariant FlashcardView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.card.id != widget.card.id) {
      _showAnswer = false;
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final rotation = _animation.value * math.pi;

          final isBack = rotation > math.pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(rotation),
            child: isBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: _buildCard(context, theme, isAnswer: true),
                  )
                : _buildCard(context, theme, isAnswer: false),
          );
        },
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    ThemeData theme, {
    required bool isAnswer,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 390),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Container(
              key: ValueKey(isAnswer),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isAnswer
                    ? AppColors.secondary.withValues(alpha: 0.10)
                    : AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isAnswer ? 'المعنى' : 'الكلمة الهولندية',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isAnswer ? AppColors.secondary : AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 36),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.94, end: 1).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              isAnswer ? widget.card.arabicMeaning : widget.card.dutchWord,
              key: ValueKey(isAnswer),
              textAlign: TextAlign.center,
              textDirection: isAnswer ? TextDirection.rtl : TextDirection.ltr,
              style: theme.textTheme.headlineLarge?.copyWith(
                color: isAnswer ? AppColors.secondary : AppColors.primary,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
          ),

          const SizedBox(height: 32),

          if (!isAnswer)
            AnimatedScale(
              scale: 1,
              duration: const Duration(milliseconds: 200),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onSpeak,
                  borderRadius: BorderRadius.circular(18),
                  child: Ink(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: AppColors.accentColor(context),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.volume_up_rounded,
                      color: AppColors.primary,
                      size: 27,
                    ),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 34),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.touch_app_rounded,
                size: 16,
                color: AppColors.subtitleColor(context),
              ),
              const SizedBox(width: 7),
              Text(
                isAnswer ? 'اضغط للعودة إلى الكلمة' : 'اضغط لإظهار المعنى',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.subtitleColor(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
