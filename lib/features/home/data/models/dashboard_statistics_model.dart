class DashboardStatisticsModel {
  final int totalStudents;
  final int totalCourses;
  final int totalLessons;
  final int totalEnrollments;

  const DashboardStatisticsModel({
    required this.totalStudents,
    required this.totalCourses,
    required this.totalLessons,
    required this.totalEnrollments,
  });

  factory DashboardStatisticsModel.fromMap(Map<String, dynamic> map) {
    return DashboardStatisticsModel(
      totalStudents: (map['total_students'] ?? 0) as int,
      totalCourses: (map['total_courses'] ?? 0) as int,
      totalLessons: (map['total_lessons'] ?? 0) as int,
      totalEnrollments: (map['total_enrollments'] ?? 0) as int,
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
