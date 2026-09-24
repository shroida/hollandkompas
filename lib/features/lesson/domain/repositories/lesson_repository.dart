import 'package:hollandkompas/features/lesson/domain/entities/lesson.dart';

abstract class LessonRepository {
  Future<List<Lesson>> getCourseLessons(String courseId);
}
