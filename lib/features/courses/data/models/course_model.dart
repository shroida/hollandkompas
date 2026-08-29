import 'dart:convert';

import 'package:hollandkompas/features/courses/domain/entities/course.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.descriptions,
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

      descriptions: _parseDescriptions(json['description']),

      level: json['level'] as String,

      imageUrl: json['image_url'] as String?,

      isPublished: json['is_published'] as bool? ?? false,

      createdBy: json['created_by'] as String?,

      createdAt: DateTime.parse(json['created_at'] as String),

      updatedAt: DateTime.parse(json['updated_at'] as String),

      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  static Map<String, String> _parseDescriptions(dynamic value) {
    if (value == null) {
      return {};
    }

    if (value is Map) {
      return value.map(
        (key, value) =>
            MapEntry(key.toString().toLowerCase(), value?.toString() ?? ''),
      );
    }

    if (value is String) {
      final text = value.trim();

      if (text.isEmpty) {
        return {};
      }

      try {
        final decoded = jsonDecode(text);

        if (decoded is Map) {
          return decoded.map(
            (key, value) =>
                MapEntry(key.toString().toLowerCase(), value?.toString() ?? ''),
          );
        }
      } catch (_) {
        // Not valid JSON.
        // Treat it as a normal English description.
      }

      return {'en': text};
    }

    return {};
  }
}
