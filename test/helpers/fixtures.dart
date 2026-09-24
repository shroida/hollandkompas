/// Realistic sample JSON/data shared across the test suite. Keeping this in
/// one place means a real schema change only needs updating here, not in
/// every test file that touches a Course or a User.
library;

// ---------------------------------------------------------------- courses
const _missingDescription = Object();

Map<String, dynamic> courseJson({
  String id = 'course-a1',
  String title = 'Nederlands A1',
  Object? description = _missingDescription,
  String level = 'A1',
  bool isPublished = true,
  double price = 4500,
}) {
  final descriptionValue = identical(description, _missingDescription)
      ? {
          'en': 'Build a strong foundation in Dutch.',
          'nl': 'Leg een sterke basis in het Nederlands.',
          'ar': 'ابنِ أساس قوي في اللغة الهولندية.',
        }
      : description;

  return {
    'id': id,
    'title': title,
    'description': descriptionValue,
    'level': level,
    'image_url': null,
    'is_published': isPublished,
    'created_by': null,
    'created_at': '2026-08-20T19:15:03.360744+00:00',
    'updated_at': '2026-08-20T19:15:03.360744+00:00',
    'price': price,
  };
} // ---------------------------------------------------------------- lessons

Map<String, dynamic> lessonJson({
  String id = 'lesson-1',
  String courseId = 'course-a1',
  String title = 'Kennismaken',
  String description = 'Learn how to introduce yourself.',
  String? videoUrl,
  String? audioUrl,
  int lessonOrder = 1,
  int durationMinutes = 30,
}) {
  return {
    'id': id,
    'course_id': courseId,
    'title': title,
    'description': description,
    'video_url': videoUrl,
    'audio_url': audioUrl,
    'lesson_order': lessonOrder,
    'duration_minutes': durationMinutes,
    'created_at': '2026-09-15T06:10:44.124345+00:00',
  };
}

// ---------------------------------------------------------------- profiles

Map<String, dynamic> profileJson({
  String id = 'user-1',
  String firstName = 'Mohamed',
  String lastName = 'Walid',
  String email = 'mohamed@example.com',
  String level = 'a1',
  String role = 'student',
  String phoneNumber = '+201000000000',
}) {
  return {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'level': level,
    'role': role,
    'phone_number': phoneNumber,
  };
}

// ------------------------------------------------------------- enrollments

Map<String, dynamic> enrollmentJson({
  String id = 'enrollment-1',
  String studentId = 'user-1',
  String courseId = 'course-a1',
  bool isPaid = false,
  double originalPrice = 4500,
  double discountPercentage = 0,
  double discountAmount = 0,
  double? finalPrice,
  String? couponCode,
  String? paymentReceiptUrl,
  String? paymentReference,
  String paymentStatus = 'pending',
  String? paymentSubmittedAt = '2026-09-17T10:00:00.000Z',
  String? paymentReviewedAt,
  String? paymentReviewedBy,
  String? enrolledAt = '2026-09-17T10:00:00.000Z',
}) {
  return {
    'id': id,
    'student_id': studentId,
    'course_id': courseId,
    'is_paid': isPaid,
    'original_price': originalPrice,
    'discount_percentage': discountPercentage,
    'discount_amount': discountAmount,
    'final_price': finalPrice ?? originalPrice,
    'coupon_code': couponCode,
    'payment_receipt_url': paymentReceiptUrl,
    'payment_reference': paymentReference,
    'payment_status': paymentStatus,
    'payment_submitted_at': paymentSubmittedAt,
    'payment_reviewed_at': paymentReviewedAt,
    'payment_reviewed_by': paymentReviewedBy,
    'enrolled_at': enrolledAt,
  };
}

// ----------------------------------------------------------------- coupons

Map<String, dynamic> couponJson({
  String code = 'WELCOME10',
  double percentage = 10,
  bool isActive = true,
  String? expiresAt,
}) {
  return {
    'code': code,
    'percentage': percentage,
    'is_active': isActive,
    'expires_at': expiresAt,
  };
}

// ------------------------------------------------------------- vocabulary

Map<String, dynamic> vocabularyWordJson({
  String id = 'word-1',
  String dutchWord = 'hallo',
  String arabicMeaning = 'مرحباً',
  String level = 'a1',
  String category = 'greetings',
}) {
  return {
    'id': id,
    'dutch_word': dutchWord,
    'arabic_meaning': arabicMeaning,
    'level': level,
    'category': category,
    'pronunciation': 'هالو',
    'example_sentence_nl': 'Hallo, hoe gaat het met je?',
    'example_sentence_ar': 'مرحباً، إزيك؟',
    'synonyms': <String>['hoi'],
    'antonyms': <String>[],
  };
}
