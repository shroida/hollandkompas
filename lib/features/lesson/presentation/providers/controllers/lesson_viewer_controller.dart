import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/lesson/presentation/providers/lesson_progress_provider.dart';

class LessonViewerState {
  final bool isSavingProgress;
  final bool isLessonCompleted;
  final bool isOpeningNextLesson;

  const LessonViewerState({
    this.isSavingProgress = false,
    this.isLessonCompleted = false,
    this.isOpeningNextLesson = false,
  });

  LessonViewerState copyWith({
    bool? isSavingProgress,
    bool? isLessonCompleted,
    bool? isOpeningNextLesson,
  }) {
    return LessonViewerState(
      isSavingProgress: isSavingProgress ?? this.isSavingProgress,
      isLessonCompleted: isLessonCompleted ?? this.isLessonCompleted,
      isOpeningNextLesson: isOpeningNextLesson ?? this.isOpeningNextLesson,
    );
  }
}

class LessonViewerController extends Notifier<LessonViewerState> {
  @override
  LessonViewerState build() {
    return const LessonViewerState();
  }

  Future<void> loadProgress({
    required String studentId,
    required String lessonId,
  }) async {
    final getLessonCompletion = ref.read(getLessonCompletionProvider);

    final completed = await getLessonCompletion(
      studentId: studentId,
      lessonId: lessonId,
    );

    state = state.copyWith(isLessonCompleted: completed);
  }

  Future<bool> completeLesson({
    required String studentId,
    required String lessonId,
  }) async {
    if (state.isSavingProgress ||
        state.isLessonCompleted ||
        state.isOpeningNextLesson) {
      return false;
    }

    state = state.copyWith(isSavingProgress: true);

    try {
      final repository = ref.read(lessonProgressRepositoryProvider);

      await repository.markLessonCompleted(
        studentId: studentId,
        lessonId: lessonId,
      );

      state = state.copyWith(isSavingProgress: false, isLessonCompleted: true);

      return true;
    } catch (e) {
      state = state.copyWith(isSavingProgress: false);

      rethrow;
    }
  }

  void setOpeningNextLesson(bool value) {
    state = state.copyWith(isOpeningNextLesson: value);
  }

  void reset() {
    state = const LessonViewerState();
  }
}
