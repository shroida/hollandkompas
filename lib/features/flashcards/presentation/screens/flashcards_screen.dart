import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/flashcards_controller.dart';
import '../widgets/flashcard_view.dart';
import '../widgets/review_buttons.dart';
import '../widgets/review_progress.dart';

class FlashcardsScreen extends ConsumerStatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  ConsumerState<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends ConsumerState<FlashcardsScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flashcardsControllerProvider);

    final controller = ref.read(flashcardsControllerProvider.notifier);

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('بطاقات مراجعة')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(state.errorMessage!, textAlign: TextAlign.center),
          ),
        ),
      );
    }

    final cards = state.cards;

    debugPrint('[FLASHCARDS-SCREEN] cards=${cards.length}');

    if (cards.isNotEmpty) {
      debugPrint(
        '[FLASHCARDS-SCREEN] '
        'FIRST ID=${cards.first.id} | '
        'WORD="${cards.first.dutchWord}" | '
        'AR="${cards.first.arabicMeaning}" | '
        'LEVEL="${cards.first.level}"',
      );
    }
    if (cards.isEmpty) {
      return _buildEmptyState(context, state);
    }

    final safeIndex = _currentIndex >= cards.length
        ? cards.length - 1
        : _currentIndex;

    final card = cards[safeIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('بطاقات مراجعة'),
        actions: [
          PopupMenuButton<FlashcardsMode>(
            onSelected: (mode) {
              _currentIndex = 0;
              controller.load(mode: mode);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: FlashcardsMode.all,
                child: Text('كل الكلمات'),
              ),
              PopupMenuItem(
                value: FlashcardsMode.daily,
                child: Text('مراجعة اليوم'),
              ),
              PopupMenuItem(
                value: FlashcardsMode.weak,
                child: Text('الكلمات الصعبة'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ReviewProgress(current: safeIndex + 1, total: cards.length),
              const SizedBox(height: 20),
              Expanded(
                child: Dismissible(
                  key: ValueKey(card.id),
                  direction: DismissDirection.horizontal,
                  confirmDismiss: (direction) async {
                    final remembered = direction == DismissDirection.endToStart
                        ? false
                        : true;

                    await controller.review(card: card, remembered: remembered);

                    if (mounted) {
                      setState(() {
                        _currentIndex = 0;
                      });
                    }

                    return false;
                  },
                  background: _swipeBackground(context, isRemember: true),
                  secondaryBackground: _swipeBackground(
                    context,
                    isRemember: false,
                  ),
                  child: FlashcardView(
                    card: card,
                    onSpeak: () {
                      controller.speak(card.dutchWord);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ReviewButtons(
                enabled: !state.isReviewing,
                onRemember: () async {
                  await controller.review(card: card, remembered: true);

                  if (mounted) {
                    setState(() {
                      _currentIndex = 0;
                    });
                  }
                },
                onForget: () async {
                  await controller.review(card: card, remembered: false);

                  if (mounted) {
                    setState(() {
                      _currentIndex = 0;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _swipeBackground(BuildContext context, {required bool isRemember}) {
    final color = isRemember ? AppColors.success : AppColors.destructive;

    return Container(
      alignment: isRemember ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(
        isRemember ? Icons.check_circle_rounded : Icons.close_rounded,
        color: color,
        size: 36,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, FlashcardsState state) {
    final modeText = switch (state.mode) {
      FlashcardsMode.all => 'لا توجد كلمات للمراجعة.',
      FlashcardsMode.daily => '🎉 لا توجد كلمات مستحقة اليوم.',
      FlashcardsMode.weak => 'لا توجد كلمات صعبة حالياً.',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('بطاقات مراجعة')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.style_rounded, size: 72, color: AppColors.primary),
              const SizedBox(height: 20),
              Text(
                modeText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'ارجع لاحقاً لمراجعة كلماتك.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
