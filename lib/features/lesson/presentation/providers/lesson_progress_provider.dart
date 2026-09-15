import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final lessonCompletionProvider = FutureProvider.autoDispose
    .family<bool, String>((ref, lessonId) async {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        return false;
      }

      final response = await Supabase.instance.client
          .from('lesson_progress')
          .select('completed')
          .eq('student_id', user.id)
          .eq('lesson_id', lessonId)
          .maybeSingle();

      return response?['completed'] == true;
    });
