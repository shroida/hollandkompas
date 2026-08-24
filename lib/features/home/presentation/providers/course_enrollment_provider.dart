import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final courseEnrollmentProvider = FutureProvider.autoDispose
    .family<bool, String>((ref, courseId) async {
      final supabase = Supabase.instance.client;

      final user = supabase.auth.currentUser;

      if (user == null) {
        return false;
      }

      try {
        final enrollment = await supabase
            .from('enrollments')
            .select('id')
            .eq('student_id', user.id)
            .eq('course_id', courseId)
            .maybeSingle();

        final isEnrolled = enrollment != null;

        return isEnrolled;
      } catch (e) {
        rethrow;
      }
    });
