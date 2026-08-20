import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/home/data/datasource/lesson_remote_data_source.dart';
import 'package:hollandkompas/features/home/data/repositories/lesson_repository_impl.dart';
import 'package:hollandkompas/features/home/domain/repositories/lesson_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final lessonRemoteDataSourceProvider = Provider<LessonRemoteDataSource>((ref) {
  return LessonRemoteDataSourceImpl(Supabase.instance.client);
});

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  return LessonRepositoryImpl(ref.watch(lessonRemoteDataSourceProvider));
});
