import 'package:hollandkompas/features/home/data/datasource/lesson_remote_data_source.dart';
import 'package:hollandkompas/features/home/domain/entities/lesson.dart';
import 'package:hollandkompas/features/home/domain/repositories/lesson_repository.dart';

class LessonRepositoryImpl implements LessonRepository {
  final LessonRemoteDataSource remoteDataSource;

  LessonRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Lesson>> getCourseLessons(String courseId) {
    return remoteDataSource.getCourseLessons(courseId);
  }
}
