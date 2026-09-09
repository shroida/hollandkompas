import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/enrolled_course.dart';
import 'package:hollandkompas/features/enrollment/presentation/providers/enrollment_provider.dart';

final enrolledCoursesProvider = FutureProvider.autoDispose
    .family<List<EnrolledCourse>, String>((ref, studentId) async {
      final repository = ref.watch(enrollmentRepositoryProvider);

      final courses = await repository.getStudentEnrollments(studentId);

      return courses;
    });
