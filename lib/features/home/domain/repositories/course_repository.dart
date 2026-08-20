import 'package:hollandkompas/features/home/domain/entities/course.dart';

abstract class CourseRepository {
  Future<List<Course>> getPublishedCourses();
}
