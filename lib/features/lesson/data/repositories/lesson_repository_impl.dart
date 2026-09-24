import 'package:hollandkompas/features/lesson/data/datasources/lesson_remote_data_source.dart';
import 'package:hollandkompas/features/lesson/domain/entities/lesson.dart';
import 'package:hollandkompas/features/lesson/domain/repositories/lesson_repository.dart';

class LessonRepositoryImpl implements LessonRepository {
  LessonRepositoryImpl(this.remoteDataSource);

  final LessonRemoteDataSource remoteDataSource;

  @override
  Future<List<Lesson>> getCourseLessons(String courseId) {
    return remoteDataSource.getCourseLessons(courseId);
  }
}
