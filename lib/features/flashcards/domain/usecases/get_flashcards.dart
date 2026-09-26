import '../entities/flashcard.dart';
import '../repositories/flashcards_repository.dart';

class GetFlashcards {
  const GetFlashcards(this._repository);

  final FlashcardsRepository _repository;

  Future<List<Flashcard>> call({bool dueOnly = false, bool weakOnly = false}) {
    return _repository.getFlashcards(dueOnly: dueOnly, weakOnly: weakOnly);
  }
}
