import 'package:hollandkompas/features/home/domain/repositories/lesson_repository.dart';

class GetLessonCompletion {
  GetLessonCompletion(this.repository);

  final LessonRepository repository;

  Future<bool> call({required String studentId, required String lessonId}) {
    return repository.getLessonCompletion(
      studentId: studentId,
      lessonId: lessonId,
    );
  }
}
