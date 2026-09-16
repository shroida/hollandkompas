import '../entities/vocabulary_word.dart';
import '../repositories/vocabulary_repository.dart';

class UpdateVocabularyProgressUseCase {
  const UpdateVocabularyProgressUseCase(this._repository);

  final VocabularyRepository _repository;

  Future<void> call(String wordId, VocabularyProgressStatus status) {
    return _repository.updateProgress(wordId, status);
  }
}
