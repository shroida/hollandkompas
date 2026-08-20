import 'package:hollandkompas/features/home/domain/entities/lesson.dart';

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
      description: json['description'] as String? ?? '',
      videoUrl: json['video_url'] as String?,
      audioUrl: json['audio_url'] as String?,
      lessonOrder: json['lesson_order'] as int? ?? 0,
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
