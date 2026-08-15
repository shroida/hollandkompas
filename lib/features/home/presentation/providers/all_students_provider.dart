import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/home/domain/entities/student.dart';
import 'package:hollandkompas/features/home/domain/usecases/get_all_students.dart';

import 'admin_dashboard_repository_provider.dart';

final allStudentsProvider = FutureProvider<List<Student>>((ref) async {
  final useCase = GetAllStudents(ref.read(adminDashboardRepositoryProvider));

  return useCase();
});
