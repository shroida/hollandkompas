import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final courseEnrollmentProvider = FutureProvider.autoDispose
    .family<bool, String>((ref, courseId) async {
      final supabase = Supabase.instance.client;

      final user = supabase.auth.currentUser;

      print('');
      print('========== ENROLLMENT CHECK ==========');
      print('Student ID: ${user?.id}');
      print('Course ID: $courseId');

      if (user == null) {
        print('No authenticated user.');
        print('======================================');
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

        print('Enrollment: $enrollment');
        print('Is enrolled: $isEnrolled');
        print('======================================');

        return isEnrolled;
      } catch (e, stackTrace) {
        print('');
        print('========== ENROLLMENT ERROR ==========');
        print('Error: $e');
        print('StackTrace: $stackTrace');
        print('======================================');

        rethrow;
      }
    });
