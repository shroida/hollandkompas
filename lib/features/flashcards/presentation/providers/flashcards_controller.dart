import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/flashcards_data_providers.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/entities/review_stats.dart';

enum FlashcardsMode { all, daily, weak }

class FlashcardsState {
  const FlashcardsState({
    this.cards = const [],
    this.stats,
    this.mode = FlashcardsMode.all,
    this.isLoading = false,
    this.isReviewing = false,
    this.errorMessage,
  });

  final List<Flashcard> cards;
  final ReviewStats? stats;
  final FlashcardsMode mode;
  final bool isLoading;
  final bool isReviewing;
  final String? errorMessage;

  FlashcardsState copyWith({
    List<Flashcard>? cards,
    ReviewStats? stats,
    FlashcardsMode? mode,
    bool? isLoading,
    bool? isReviewing,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FlashcardsState(
      cards: cards ?? this.cards,
      stats: stats ?? this.stats,
      mode: mode ?? this.mode,
      isLoading: isLoading ?? this.isLoading,
      isReviewing: isReviewing ?? this.isReviewing,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final flashcardsControllerProvider =
    NotifierProvider<FlashcardsController, FlashcardsState>(
      FlashcardsController.new,
    );

class FlashcardsController extends Notifier<FlashcardsState> {
  @override
  FlashcardsState build() {
    Future.microtask(() {
      load();
    });

    return const FlashcardsState();
  }

  Future<void> load({FlashcardsMode mode = FlashcardsMode.all}) async {
    debugPrint('[FLASHCARDS-CONTROLLER] LOAD START | mode=$mode');

    state = state.copyWith(isLoading: true, mode: mode, clearError: true);

    try {
      final repository = ref.read(flashcardsRepositoryProvider);

      debugPrint('[FLASHCARDS-CONTROLLER] Loading cards...');

      final cards = await repository.getFlashcards(
        dueOnly: mode == FlashcardsMode.daily,
        weakOnly: mode == FlashcardsMode.weak,
      );

      debugPrint(
        '[FLASHCARDS-CONTROLLER] '
        'CARDS LOADED: ${cards.length}',
      );

      // IMPORTANT:
      // Show the cards immediately.
      state = state.copyWith(cards: cards, isLoading: false, clearError: true);

      // Load statistics separately.
      try {
        debugPrint('[FLASHCARDS-CONTROLLER] Loading stats...');

        final stats = await repository.getReviewStats();

        debugPrint(
          '[FLASHCARDS-CONTROLLER] '
          'STATS LOADED | '
          'total=${stats.total} | '
          'due=${stats.dueToday} | '
          'weak=${stats.weakWords} | '
          'mastered=${stats.mastered}',
        );

        if (!ref.mounted) {
          return;
        }

        state = state.copyWith(stats: stats);
      } catch (error, stackTrace) {
        debugPrint(
          '[FLASHCARDS-CONTROLLER] '
          'STATS FAILED: $error',
        );

        debugPrintStack(stackTrace: stackTrace);

        // Stats are optional.
        // Cards should remain visible.
      }
    } catch (error, stackTrace) {
      debugPrint(
        '[FLASHCARDS-CONTROLLER] '
        'LOAD FAILED: $error',
      );

      debugPrintStack(stackTrace: stackTrace);

      if (!ref.mounted) {
        return;
      }

      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> review({
    required Flashcard card,
    required bool remembered,
  }) async {
    if (state.isReviewing) {
      return;
    }

    state = state.copyWith(isReviewing: true, clearError: true);

    try {
      final repository = ref.read(flashcardsRepositoryProvider);

      await repository.reviewFlashcard(wordId: card.id, remembered: remembered);

      if (!ref.mounted) {
        return;
      }

      final remainingCards = state.cards
          .where((item) => item.id != card.id)
          .toList(growable: false);

      state = state.copyWith(cards: remainingCards, isReviewing: false);

      try {
        final stats = await repository.getReviewStats();

        if (!ref.mounted) {
          return;
        }

        state = state.copyWith(stats: stats);
      } catch (error, stackTrace) {
        debugPrint(
          '[FLASHCARDS-CONTROLLER] '
          'REFRESH STATS FAILED: $error',
        );

        debugPrintStack(stackTrace: stackTrace);
      }
    } catch (error, stackTrace) {
      debugPrint(
        '[FLASHCARDS-CONTROLLER] '
        'REVIEW FAILED | '
        'word=${card.id} | '
        'remembered=$remembered | '
        '$error',
      );

      debugPrintStack(stackTrace: stackTrace);

      if (!ref.mounted) {
        return;
      }

      state = state.copyWith(
        isReviewing: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> speak(String text) {
    return ref.read(flashcardsRepositoryProvider).speak(text);
  }

  Future<void> stopSpeaking() {
    return ref.read(flashcardsRepositoryProvider).stopSpeaking();
  }
}
