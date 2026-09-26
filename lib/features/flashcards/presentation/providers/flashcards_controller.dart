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
    state = state.copyWith(isLoading: true, mode: mode, clearError: true);

    try {
      final repository = ref.read(flashcardsRepositoryProvider);

      final cards = await repository.getFlashcards(
        dueOnly: mode == FlashcardsMode.daily,
        weakOnly: mode == FlashcardsMode.weak,
      );

      // IMPORTANT:
      // Show the cards immediately.
      state = state.copyWith(cards: cards, isLoading: false, clearError: true);

      // Load statistics separately.
      try {
        final stats = await repository.getReviewStats();

        if (!ref.mounted) {
          return;
        }

        state = state.copyWith(stats: stats);
      } catch (error, stackTrace) {
        debugPrintStack(stackTrace: stackTrace);

        // Stats are optional.
        // Cards should remain visible.
      }
    } catch (error, stackTrace) {
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
        debugPrintStack(stackTrace: stackTrace);
      }
    } catch (error, stackTrace) {
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
