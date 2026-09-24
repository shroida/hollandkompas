import 'package:hollandkompas/features/lesson/domain/repositories/lesson_progress_repository.dart';

class GetLessonCompletion {
  final LessonProgressRepository repository;

  GetLessonCompletion(this.repository);

  Future<bool> call({required String studentId, required String lessonId}) {
    return repository.getLessonCompletion(
      studentId: studentId,
      lessonId: lessonId,
    );
  }
}
