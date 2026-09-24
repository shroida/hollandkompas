import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/lesson/data/repositories/lesson_progress_repository_impl.dart';
import 'package:hollandkompas/features/lesson/domain/repositories/lesson_progress_repository.dart';
import 'package:hollandkompas/features/lesson/domain/usecases/get_lesson_completion.dart';

final lessonProgressRepositoryProvider = Provider<LessonProgressRepository>((
  ref,
) {
  return LessonProgressRepositoryImpl();
});

final getLessonCompletionProvider = Provider<GetLessonCompletion>((ref) {
  return GetLessonCompletion(ref.watch(lessonProgressRepositoryProvider));
});
