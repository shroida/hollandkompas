import 'package:hollandkompas/features/courses/domain/entities/course.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.level,
    required super.imageUrl,
    required super.isPublished,
    required super.createdBy,
    required super.createdAt,
    required super.updatedAt,
    required super.price,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,

      title: json['title'] as String,

      description: json['description'] as String? ?? '',

      level: json['level'] as String,

      price: (json['price'] as num?)?.toDouble() ?? 0.0,

      imageUrl: json['image_url'] as String?,

      isPublished: json['is_published'] as bool? ?? false,

      createdBy: json['created_by'] as String?,

      createdAt: DateTime.parse(json['created_at'] as String),

      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
