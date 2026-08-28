import 'package:hollandkompas/features/courses/domain/entities/course.dart';

abstract class CourseRepository {
  Future<List<Course>> getPublishedCourses();
}
