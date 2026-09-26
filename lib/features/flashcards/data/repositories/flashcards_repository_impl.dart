import '../../domain/entities/flashcard.dart';
import '../../domain/entities/review_stats.dart';
import '../../domain/repositories/flashcards_repository.dart';
import '../datasources/flashcards_remote_data_source.dart';

class FlashcardsRepositoryImpl implements FlashcardsRepository {
  const FlashcardsRepositoryImpl(this._remote);

  final FlashcardsRemoteDataSource _remote;

  @override
  Future<List<Flashcard>> getFlashcards({
    bool dueOnly = false,
    bool weakOnly = false,
  }) async {
    final models = await _remote.getFlashcards(
      dueOnly: dueOnly,
      weakOnly: weakOnly,
    );

    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  @override
  Future<void> reviewFlashcard({
    required String wordId,
    required bool remembered,
  }) {
    return _remote.reviewFlashcard(wordId: wordId, remembered: remembered);
  }

  @override
  Future<ReviewStats> getReviewStats() {
    return _remote.getReviewStats();
  }

  @override
  Future<void> speak(String text) {
    return _remote.speak(text);
  }

  @override
  Future<void> stopSpeaking() {
    return _remote.stopSpeaking();
  }
}
