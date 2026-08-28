import 'package:hollandkompas/features/courses/data/models/course_model.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/enrolled_course.dart';

class EnrolledCourseModel extends EnrolledCourse {
  const EnrolledCourseModel({
    required super.course,
    required super.enrolledAt,
    required super.totalLessons,
    required super.completedLessons,
  });

  factory EnrolledCourseModel.fromJson(
    Map<String, dynamic> json, {
    Map<String, dynamic>? course,
    int totalLessons = 0,
    int completedLessons = 0,
  }) {
    final rawCourse = course ?? json['courses'];

    if (rawCourse == null) {
      throw Exception('Course data is missing for enrollment ${json['id']}');
    }

    final courseModel = CourseModel.fromJson(
      Map<String, dynamic>.from(rawCourse),
    );

    final enrolledAtValue = json['enrolled_at'];

    if (enrolledAtValue == null) {
      throw Exception('enrolled_at is missing for enrollment ${json['id']}');
    }

    return EnrolledCourseModel(
      course: courseModel,
      enrolledAt: DateTime.parse(enrolledAtValue.toString()),
      totalLessons: totalLessons,
      completedLessons: completedLessons,
    );
  }
}
