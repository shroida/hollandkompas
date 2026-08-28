import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/enrolled_course.dart';
import 'package:hollandkompas/features/enrollment/presentation/providers/enrollment_provider.dart';

final enrolledCoursesProvider =
    FutureProvider.family<List<EnrolledCourse>, String>((ref, studentId) async {
      final repository = ref.read(enrollmentRepositoryProvider);

      return repository.getStudentEnrollments(studentId);
    });
