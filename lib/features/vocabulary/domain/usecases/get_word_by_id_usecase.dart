import '../entities/vocabulary_word.dart';
import '../repositories/vocabulary_repository.dart';

class GetWordByIdUseCase {
  const GetWordByIdUseCase(this._repository);

  final VocabularyRepository _repository;

  Future<VocabularyWord> call(String id) => _repository.getWordById(id);
}
