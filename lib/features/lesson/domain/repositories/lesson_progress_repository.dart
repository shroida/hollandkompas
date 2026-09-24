abstract class LessonProgressRepository {
  Future<bool> getLessonCompletion({
    required String studentId,
    required String lessonId,
  });

  Future<void> markLessonCompleted({
    required String studentId,
    required String lessonId,
  });
}
