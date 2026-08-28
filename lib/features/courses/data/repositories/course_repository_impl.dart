import 'package:hollandkompas/features/courses/data/datasource/course_remote_data_source.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/domain/repositories/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;

  CourseRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Course>> getPublishedCourses() {
    return remoteDataSource.getPublishedCourses();
  }
}
