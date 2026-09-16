import '../entities/vocabulary_word.dart';
import '../repositories/vocabulary_repository.dart';

class GetDailyWordUseCase {
  const GetDailyWordUseCase(this._repository);

  final VocabularyRepository _repository;

  Future<VocabularyWord> call() => _repository.getDailyWord();
}
