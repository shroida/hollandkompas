import '../entities/vocabulary_stats.dart';
import '../repositories/vocabulary_repository.dart';

class GetVocabularyStatsUseCase {
  const GetVocabularyStatsUseCase(this._repository);

  final VocabularyRepository _repository;

  Future<VocabularyStats> call() => _repository.getProgressStats();
}
