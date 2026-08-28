import 'package:hollandkompas/features/enrollment/domain/entities/enrollment.dart';

class EnrollmentModel extends Enrollment {
  const EnrollmentModel({
    required super.id,
    required super.studentId,
    required super.courseId,
    required super.isPaid,
    required super.originalPrice,
    required super.discountPercentage,
    required super.discountAmount,
    required super.finalPrice,
    required super.couponCode,
    required super.paymentReceiptUrl,
    required super.paymentReference,
    required super.paymentStatus,
    required super.paymentSubmittedAt,
    required super.paymentReviewedAt,
    required super.paymentReviewedBy,
    required super.enrolledAt,
  });

  factory EnrollmentModel.fromMap(Map<String, dynamic> map) {
    return EnrollmentModel(
      id: map['id']?.toString() ?? '',
      studentId: map['student_id']?.toString() ?? '',
      courseId: map['course_id']?.toString() ?? '',

      isPaid: map['is_paid'] as bool? ?? false,

      originalPrice: (map['original_price'] as num?)?.toDouble() ?? 0,
      discountPercentage: (map['discount_percentage'] as num?)?.toDouble() ?? 0,
      discountAmount: (map['discount_amount'] as num?)?.toDouble() ?? 0,
      finalPrice: (map['final_price'] as num?)?.toDouble() ?? 0,

      couponCode: map['coupon_code']?.toString(),

      paymentReceiptUrl: map['payment_receipt_url']?.toString(),
      paymentReference: map['payment_reference']?.toString(),

      paymentStatus: map['payment_status']?.toString() ?? 'pending',

      paymentSubmittedAt: _parseDate(map['payment_submitted_at']),
      paymentReviewedAt: _parseDate(map['payment_reviewed_at']),

      paymentReviewedBy: map['payment_reviewed_by']?.toString(),

      enrolledAt: _parseDate(map['enrolled_at']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(value.toString());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'course_id': courseId,
      'is_paid': isPaid,
      'original_price': originalPrice,
      'discount_percentage': discountPercentage,
      'discount_amount': discountAmount,
      'final_price': finalPrice,
      'coupon_code': couponCode,
      'payment_receipt_url': paymentReceiptUrl,
      'payment_reference': paymentReference,
      'payment_status': paymentStatus,
      'payment_submitted_at': paymentSubmittedAt?.toIso8601String(),
      'payment_reviewed_at': paymentReviewedAt?.toIso8601String(),
      'payment_reviewed_by': paymentReviewedBy,
      'enrolled_at': enrolledAt?.toIso8601String(),
    };
  }
}
