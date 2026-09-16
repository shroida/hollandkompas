import '../entities/vocabulary_word.dart';
import '../repositories/vocabulary_repository.dart';

class GetFavoriteWordsUseCase {
  const GetFavoriteWordsUseCase(this._repository);

  final VocabularyRepository _repository;

  Future<List<VocabularyWord>> call() => _repository.getFavoriteWords();
}
