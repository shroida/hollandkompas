import 'package:hollandkompas/features/home/domain/entities/dashboard_statistics.dart';

class DashboardStatisticsModel extends DashboardStatistics {
  const DashboardStatisticsModel({
    required super.totalStudents,
    required super.totalCourses,
    required super.totalLessons,
    required super.totalEnrollments,
  });

  factory DashboardStatisticsModel.fromMap(Map<String, dynamic> map) {
    return DashboardStatisticsModel(
      totalStudents: map['total_students'] ?? 0,
      totalCourses: map['total_courses'] ?? 0,
      totalLessons: map['total_lessons'] ?? 0,
      totalEnrollments: map['total_enrollments'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total_students': totalStudents,
      'total_courses': totalCourses,
      'total_lessons': totalLessons,
      'total_enrollments': totalEnrollments,
    };
  }
}
