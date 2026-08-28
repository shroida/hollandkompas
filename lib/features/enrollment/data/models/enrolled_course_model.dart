import 'package:hollandkompas/features/enrollment/domain/entities/enrolled_course.dart';
import 'package:hollandkompas/features/home/data/models/course_model.dart';

class EnrolledCourseModel extends EnrolledCourse {
  const EnrolledCourseModel({
    required super.course,
    required super.enrolledAt,
    required super.totalLessons,
    required super.completedLessons,
  });

  factory EnrolledCourseModel.fromJson(Map<String, dynamic> json) {
    final rawCourse = json['courses'];

    if (rawCourse == null) {
      throw Exception('Course data is missing for enrollment ${json['id']}');
    }

    final course = CourseModel.fromJson(Map<String, dynamic>.from(rawCourse));

    return EnrolledCourseModel(
      course: course,
      enrolledAt: DateTime.parse(json['enrolled_at'] as String),
      totalLessons: 0,
      completedLessons: 0,
    );
  }
}
