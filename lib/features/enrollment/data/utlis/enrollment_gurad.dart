enum EnrollmentGuardResult { allowed, alreadyEnrolled, paymentPending }

EnrollmentGuardResult checkEnrollmentGuard({
  required bool? isPaid,
  required String? paymentStatus,
}) {
  if (isPaid == true) {
    return EnrollmentGuardResult.alreadyEnrolled;
  }

  if (paymentStatus == 'approved') {
    return EnrollmentGuardResult.alreadyEnrolled;
  }

  if (paymentStatus == 'pending') {
    return EnrollmentGuardResult.paymentPending;
  }

  return EnrollmentGuardResult.allowed;
}

String? enrollmentGuardMessage(EnrollmentGuardResult result) {
  switch (result) {
    case EnrollmentGuardResult.allowed:
      return null;
    case EnrollmentGuardResult.alreadyEnrolled:
      return 'You are already enrolled in this course.';
    case EnrollmentGuardResult.paymentPending:
      return 'You already have a payment request waiting for review.';
  }
}
