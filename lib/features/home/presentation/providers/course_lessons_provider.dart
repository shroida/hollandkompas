import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/network/supabase_client.dart';
import 'package:hollandkompas/features/lesson/data/datasources/lesson_remote_data_source.dart';
import 'package:hollandkompas/features/lesson/domain/entities/lesson.dart';

final lessonRemoteDataSourceProvider = Provider<LessonRemoteDataSource>((ref) {
  return LessonRemoteDataSourceImpl(SupabaseManager.client);
});

final courseLessonsProvider = FutureProvider.autoDispose
    .family<List<Lesson>, String>((ref, courseId) async {
      final dataSource = ref.read(lessonRemoteDataSourceProvider);

      return dataSource.getCourseLessons(courseId);
    });
