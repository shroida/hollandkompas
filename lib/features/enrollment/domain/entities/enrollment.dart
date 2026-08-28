class Enrollment {
  final String id;
  final String studentId;
  final String courseId;

  final bool isPaid;

  final double originalPrice;
  final double discountPercentage;
  final double discountAmount;
  final double finalPrice;

  final String? couponCode;

  final String? paymentReceiptUrl;
  final String? paymentReference;

  final String paymentStatus;

  final DateTime? paymentSubmittedAt;
  final DateTime? paymentReviewedAt;
  final String? paymentReviewedBy;

  final DateTime? enrolledAt;

  const Enrollment({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.isPaid,
    required this.originalPrice,
    required this.discountPercentage,
    required this.discountAmount,
    required this.finalPrice,
    required this.couponCode,
    required this.paymentReceiptUrl,
    required this.paymentReference,
    required this.paymentStatus,
    required this.paymentSubmittedAt,
    required this.paymentReviewedAt,
    required this.paymentReviewedBy,
    required this.enrolledAt,
  });

  bool get isPending => paymentStatus == 'pending';

  bool get isApproved => paymentStatus == 'approved';

  bool get isRejected => paymentStatus == 'rejected';
}
