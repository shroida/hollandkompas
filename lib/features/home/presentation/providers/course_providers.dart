import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/network/app_exception.dart';
import 'package:hollandkompas/features/courses/data/datasource/course_remote_data_source.dart';
import 'package:hollandkompas/features/courses/data/datasource/course_remote_data_source_impl.dart';
import 'package:hollandkompas/features/courses/data/repositories/course_repository_impl.dart';
import 'package:hollandkompas/features/home/domain/repositories/course_repository.dart';

final courseRemoteDataSourceProvider = Provider<CourseRemoteDataSource>((ref) {
  return CourseRemoteDataSourceImpl(ref.watch(supabaseClientProvider));
});

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepositoryImpl(ref.watch(courseRemoteDataSourceProvider));
});
