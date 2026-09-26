import '../entities/flashcard.dart';
import '../entities/review_stats.dart';

abstract interface class FlashcardsRepository {
  Future<List<Flashcard>> getFlashcards({
    bool dueOnly = false,
    bool weakOnly = false,
  });

  Future<void> reviewFlashcard({
    required String wordId,
    required bool remembered,
  });

  Future<ReviewStats> getReviewStats();

  Future<void> speak(String text);

  Future<void> stopSpeaking();
}
