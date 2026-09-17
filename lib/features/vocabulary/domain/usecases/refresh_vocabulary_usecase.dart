import '../repositories/vocabulary_repository.dart';

class RefreshVocabularyUseCase {
  const RefreshVocabularyUseCase(this._repository);

  final VocabularyRepository _repository;

  Future<void> call() {
    return _repository.refresh();
  }
}
