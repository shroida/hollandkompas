import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/lesson/presentation/providers/lesson_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final lessonCompletionProvider = FutureProvider.autoDispose
    .family<bool, String>((ref, lessonId) async {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        return false;
      }

      final getLessonCompletion = ref.read(getLessonCompletionProvider);

      return getLessonCompletion(studentId: user.id, lessonId: lessonId);
    });
