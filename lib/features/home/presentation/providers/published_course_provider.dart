import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/home/domain/entities/course.dart';
import 'package:hollandkompas/features/home/presentation/providers/course_providers.dart';

final publishedCoursesProvider = FutureProvider<List<Course>>((ref) async {
  final repository = ref.watch(courseRepositoryProvider);

  return repository.getPublishedCourses();
});
