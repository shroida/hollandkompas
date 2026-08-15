import 'package:hollandkompas/features/home/domain/entities/student.dart';
import 'package:hollandkompas/features/home/domain/repositories/admin_dashboard_repository.dart';

class GetAllStudents {
  final AdminDashboardRepository repository;

  const GetAllStudents(this.repository);

  Future<List<Student>> call() {
    return repository.getAllStudents();
  }
}
