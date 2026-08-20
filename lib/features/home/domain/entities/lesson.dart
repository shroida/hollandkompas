class Lesson {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final String? videoUrl;
  final String? audioUrl;
  final int lessonOrder;
  final int durationMinutes;
  final DateTime createdAt;

  const Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.audioUrl,
    required this.lessonOrder,
    required this.durationMinutes,
    required this.createdAt,
  });
}
