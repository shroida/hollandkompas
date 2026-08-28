import 'package:hollandkompas/features/home/data/models/course_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getPublishedCourses();
}
