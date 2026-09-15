import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/home/presentation/providers/lesson_remote_data_source_provider.dart';
import 'package:hollandkompas/features/lesson/domain/entities/lesson.dart';

final courseLessonsProvider = FutureProvider.family<List<Lesson>, String>((
  ref,
  courseId,
) async {
  final repository = ref.watch(lessonRepositoryProvider);

  return repository.getCourseLessons(courseId);
});
