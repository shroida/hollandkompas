import 'package:hollandkompas/features/home/domain/entities/lesson.dart';

abstract class LessonRepository {
  Future<List<Lesson>> getCourseLessons(String courseId);
}
