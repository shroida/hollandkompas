import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/lesson/presentation/providers/controllers/lesson_viewer_controller.dart';

final lessonViewerControllerProvider =
    NotifierProvider<LessonViewerController, LessonViewerState>(
      LessonViewerController.new,
    );
