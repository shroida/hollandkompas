import '../entities/vocabulary_word.dart';
import '../repositories/vocabulary_repository.dart';

class SearchVocabularyUseCase {
  const SearchVocabularyUseCase(this._repository);

  final VocabularyRepository _repository;

  Future<List<VocabularyWord>> call(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return Future.value(const []);
    return _repository.searchWords(trimmed);
  }
}
