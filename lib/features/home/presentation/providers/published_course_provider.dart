import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/providers/course_providers.dart';

final publishedCoursesProvider = FutureProvider<List<Course>>((ref) async {
  final repository = ref.watch(courseRepositoryProvider);

  return repository.getPublishedCourses();
});
