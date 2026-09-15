import 'package:hollandkompas/features/lesson/domain/entities/lesson.dart';

class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.courseId,
    required super.title,
    required super.description,
    required super.videoUrl,
    required super.audioUrl,
    required super.lessonOrder,
    required super.durationMinutes,
    required super.createdAt,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      videoUrl: json['video_url'] as String?,
      audioUrl: json['audio_url'] as String?,
      lessonOrder: json['lesson_order'] as int,
      durationMinutes: json['duration_minutes'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'description': description,
      'video_url': videoUrl,
      'audio_url': audioUrl,
      'lesson_order': lessonOrder,
      'duration_minutes': durationMinutes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
