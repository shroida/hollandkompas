import 'package:hollandkompas/features/enrollment/data/models/coupon_model.dart';
import 'package:hollandkompas/features/enrollment/data/models/enrolled_course_model.dart';
import 'package:hollandkompas/features/enrollment/data/models/enrollment_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class EnrollmentRemoteDataSource {
  Future<CouponModel?> getCoupon(String code);

  Future<List<EnrolledCourseModel>> getStudentEnrollments(String studentId);
  Future<EnrollmentModel> createPaymentRequest({
    required String courseId,
    required double originalPrice,
    required double discountPercentage,
    required double discountAmount,
    required double finalPrice,
    required String? couponCode,
    required XFile receipt,
    required String paymentReference,
  });

  Future<EnrollmentModel?> getStudentEnrollment({
    required String studentId,
    required String courseId,
  });
}

class EnrollmentRemoteDataSourceImpl implements EnrollmentRemoteDataSource {
  final SupabaseClient supabase;

  EnrollmentRemoteDataSourceImpl({required this.supabase});

  @override
  Future<CouponModel?> getCoupon(String code) async {
    final response = await supabase
        .from('coupons')
        .select('code, percentage, is_active, expires_at')
        .eq('code', code)
        .eq('is_active', true)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return CouponModel.fromJson(Map<String, dynamic>.from(response));
  }

  @override
  Future<List<EnrolledCourseModel>> getStudentEnrollments(
    String studentId,
  ) async {
    // ------------------------------------------------------------
    // 1. Get student's enrollments + course information
    // ------------------------------------------------------------

    final enrollmentResponse = await supabase
        .from('enrollments')
        .select('''
          id,
          student_id,
          course_id,
          enrolled_at,
          courses (
            id,
            title,
            description,
            level,
            image_url,
            is_published,
            created_by,
            created_at,
            updated_at,
            price
          )
        ''')
        .eq('student_id', studentId)
        .order('enrolled_at', ascending: false);

    final enrollments = List<Map<String, dynamic>>.from(enrollmentResponse);

    if (enrollments.isEmpty) {
      return [];
    }

    final result = <EnrolledCourseModel>[];

    // ------------------------------------------------------------
    // 2. For every enrollment:
    //    - Get all lessons of the course
    //    - Get completed lessons of the student
    // ------------------------------------------------------------

    for (final enrollment in enrollments) {
      final rawCourse = enrollment['courses'];

      if (rawCourse == null) {
        continue;
      }

      final course = Map<String, dynamic>.from(rawCourse);

      final courseId = enrollment['course_id'] as String;

      // ----------------------------------------------------------
      // Get total lessons
      // ----------------------------------------------------------

      final lessonsResponse = await supabase
          .from('lessons')
          .select('id')
          .eq('course_id', courseId);

      final lessons = List<Map<String, dynamic>>.from(lessonsResponse);

      final totalLessons = lessons.length;

      // ----------------------------------------------------------
      // Get completed lessons
      // ----------------------------------------------------------

      int completedLessons = 0;

      if (lessons.isNotEmpty) {
        final lessonIds = lessons
            .map((lesson) => lesson['id'] as String)
            .toList();

        final progressResponse = await supabase
            .from('lesson_progress')
            .select('lesson_id, completed')
            .eq('student_id', studentId)
            .eq('completed', true)
            .inFilter('lesson_id', lessonIds);

        completedLessons = progressResponse.length;
      }

      // ----------------------------------------------------------
      // Build model
      // ----------------------------------------------------------

      result.add(
        EnrolledCourseModel.fromJson(
          enrollment,
          course: course,
          totalLessons: totalLessons,
          completedLessons: completedLessons,
        ),
      );
    }

    return result;
  }

  static const String receiptBucket = 'payment-receipts';

  @override
  Future<EnrollmentModel> createPaymentRequest({
    required String courseId,
    required double originalPrice,
    required double discountPercentage,
    required double discountAmount,
    required double finalPrice,
    required String? couponCode,
    required XFile receipt,
    required String paymentReference,
  }) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated.');
    }

    // Prevent duplicate pending/paid enrollment.
    final existing = await supabase
        .from('enrollments')
        .select('id, is_paid, payment_status')
        .eq('student_id', user.id)
        .eq('course_id', courseId)
        .maybeSingle();

    if (existing != null) {
      final isPaid = existing['is_paid'] as bool? ?? false;
      final status = existing['payment_status']?.toString();

      if (isPaid || status == 'approved') {
        throw Exception('You are already enrolled in this course.');
      }

      if (status == 'pending') {
        throw Exception(
          'You already have a payment request waiting for review.',
        );
      }
    }

    final bytes = await receipt.readAsBytes();

    final extension = _getExtension(receipt.name);

    final filePath =
        '${user.id}/$courseId/${DateTime.now().millisecondsSinceEpoch}.$extension';

    await supabase.storage
        .from(receiptBucket)
        .uploadBinary(
          filePath,
          bytes,
          fileOptions: FileOptions(
            contentType: _getContentType(extension),
            upsert: false,
          ),
        );

    final receiptUrl = supabase.storage
        .from(receiptBucket)
        .getPublicUrl(filePath);

    final response = await supabase
        .from('enrollments')
        .insert({
          'student_id': user.id,
          'course_id': courseId,

          'is_paid': false,

          'original_price': originalPrice,
          'discount_percentage': discountPercentage,
          'discount_amount': discountAmount,
          'final_price': finalPrice,

          'coupon_code': couponCode,

          'payment_receipt_url': receiptUrl,
          'payment_reference': paymentReference,

          'payment_status': 'pending',

          'payment_submitted_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return EnrollmentModel.fromMap(Map<String, dynamic>.from(response));
  }

  @override
  Future<EnrollmentModel?> getStudentEnrollment({
    required String studentId,
    required String courseId,
  }) async {
    final response = await supabase
        .from('enrollments')
        .select()
        .eq('student_id', studentId)
        .eq('course_id', courseId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return EnrollmentModel.fromMap(Map<String, dynamic>.from(response));
  }

  String _getExtension(String fileName) {
    final parts = fileName.split('.');

    if (parts.length < 2) {
      return 'jpg';
    }

    return parts.last.toLowerCase();
  }

  String _getContentType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';

      case 'png':
        return 'image/png';

      case 'webp':
        return 'image/webp';

      case 'gif':
        return 'image/gif';

      default:
        return 'application/octet-stream';
    }
  }
}
