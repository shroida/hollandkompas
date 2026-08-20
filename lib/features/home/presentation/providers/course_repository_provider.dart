import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/home/data/repositories/course_repository_impl.dart';
import 'package:hollandkompas/features/home/domain/repositories/course_repository.dart';
import 'package:hollandkompas/features/home/presentation/providers/course_providers.dart';

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepositoryImpl(ref.watch(courseRemoteDataSourceProvider));
});
