import '../entities/review_stats.dart';
import '../repositories/flashcards_repository.dart';

class GetReviewStats {
  const GetReviewStats(this._repository);

  final FlashcardsRepository _repository;

  Future<ReviewStats> call() {
    return _repository.getReviewStats();
  }
}
