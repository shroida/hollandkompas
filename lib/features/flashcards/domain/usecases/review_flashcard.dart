import '../repositories/flashcards_repository.dart';

class ReviewFlashcard {
  const ReviewFlashcard(this._repository);

  final FlashcardsRepository _repository;

  Future<void> call({required String wordId, required bool remembered}) {
    return _repository.reviewFlashcard(wordId: wordId, remembered: remembered);
  }
}
