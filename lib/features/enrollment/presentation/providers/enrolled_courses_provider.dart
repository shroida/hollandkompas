import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/enrollment/data/datasources/enrollment_remote_data_source.dart';
import 'package:hollandkompas/features/enrollment/data/repositories/enrollment_repository_impl.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/enrolled_course.dart';
import 'package:hollandkompas/features/home/domain/repositories/enrollment_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final enrollmentRemoteDataSourceProvider = Provider<EnrollmentRemoteDataSource>(
  (ref) {
    return EnrollmentRemoteDataSourceImpl(supabase: Supabase.instance.client);
  },
);

final enrollmentRepositoryProvider = Provider<EnrollmentRepository>((ref) {
  return EnrollmentRepositoryImpl(ref.read(enrollmentRemoteDataSourceProvider));
});

final enrolledCoursesProvider =
    FutureProvider.family<List<EnrolledCourse>, String>((ref, studentId) async {
      final repository = ref.read(enrollmentRepositoryProvider);

      return repository.getStudentEnrollments(studentId);
    });
