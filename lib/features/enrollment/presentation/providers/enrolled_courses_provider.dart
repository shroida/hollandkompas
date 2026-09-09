import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/enrolled_course.dart';
import 'package:hollandkompas/features/enrollment/presentation/providers/enrollment_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final enrolledCoursesProvider = FutureProvider.autoDispose
    .family<List<EnrolledCourse>, String>((ref, studentId) async {
      final supabaseUser = Supabase.instance.client.auth.currentUser;

      debugPrint('======================================');
      debugPrint('ENROLLED COURSES PROVIDER');
      debugPrint('studentId argument: $studentId');
      debugPrint('Supabase user ID: ${supabaseUser?.id}');
      debugPrint('Supabase user email: ${supabaseUser?.email}');
      debugPrint('======================================');

      final repository = ref.watch(enrollmentRepositoryProvider);

      final courses = await repository.getStudentEnrollments(studentId);

      debugPrint('Returned courses: ${courses.length}');

      for (final course in courses) {
        debugPrint(
          'Course: ${course.course.title} | '
          'Progress: ${course.progress}',
        );
      }

      debugPrint('======================================');

      return courses;
    });
