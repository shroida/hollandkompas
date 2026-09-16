import '../repositories/vocabulary_repository.dart';

class ToggleFavoriteWordUseCase {
  const ToggleFavoriteWordUseCase(this._repository);

  final VocabularyRepository _repository;

  Future<void> call(String wordId, bool isFavorite) {
    return _repository.setFavorite(wordId, isFavorite);
  }
}
