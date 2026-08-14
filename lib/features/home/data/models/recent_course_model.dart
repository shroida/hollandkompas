class RecentCourseModel {
  final String id;
  final String title;
  final String level;
  final bool isPublished;
  final DateTime createdAt;

  RecentCourseModel({
    required this.id,
    required this.title,
    required this.level,
    required this.isPublished,
    required this.createdAt,
  });
}
