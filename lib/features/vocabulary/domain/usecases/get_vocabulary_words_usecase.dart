import '../entities/vocabulary_word.dart';
import '../repositories/vocabulary_repository.dart';

class GetVocabularyWordsUseCase {
  const GetVocabularyWordsUseCase(this._repository);

  final VocabularyRepository _repository;

  Future<List<VocabularyWord>> call({
    VocabularyLevel? level,
    VocabularyCategory? category,
  }) {
    return _repository.getWords(level: level, category: category);
  }
}
