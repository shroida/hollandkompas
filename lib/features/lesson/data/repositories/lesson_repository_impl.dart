import 'package:hollandkompas/features/home/domain/repositories/lesson_repository.dart';
import 'package:hollandkompas/features/lesson/data/datasources/lesson_remote_data_source.dart';
import 'package:hollandkompas/features/lesson/domain/entities/lesson.dart';

class LessonRepositoryImpl implements LessonRepository {
  LessonRepositoryImpl(this.remoteDataSource);

  final LessonRemoteDataSource remoteDataSource;

  @override
  Future<List<Lesson>> getCourseLessons(String courseId) {
    return remoteDataSource.getCourseLessons(courseId);
  }

  @override
  Future<bool> getLessonCompletion({
    required String studentId,
    required String lessonId,
  }) {
    return remoteDataSource.getLessonCompletion(
      studentId: studentId,
      lessonId: lessonId,
    );
  }
}
