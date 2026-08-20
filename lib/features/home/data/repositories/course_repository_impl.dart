import 'package:hollandkompas/features/home/data/datasource/course_remote_data_source.dart';
import 'package:hollandkompas/features/home/domain/entities/course.dart';
import 'package:hollandkompas/features/home/domain/repositories/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;

  CourseRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Course>> getPublishedCourses() {
    return remoteDataSource.getPublishedCourses();
  }
}
