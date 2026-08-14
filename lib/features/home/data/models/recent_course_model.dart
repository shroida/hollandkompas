import 'package:hollandkompas/features/home/domain/entities/recent_course.dart';

class RecentCourseModel extends RecentCourse {
  const RecentCourseModel({
    required super.id,
    required super.title,
    required super.level,
    required super.isPublished,
    required super.createdAt,
  });

  factory RecentCourseModel.fromMap(Map<String, dynamic> map) {
    return RecentCourseModel(
      id: map['id'],
      title: map['title'],
      level: map['level'],
      isPublished: map['is_published'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'level': level,
      'is_published': isPublished,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
