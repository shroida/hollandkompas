import 'package:flutter_test/flutter_test.dart';
import 'package:hollandkompas/features/enrollment/data/utlis/enrollment_gurad.dart';

void main() {
  group('checkEnrollmentGuard', () {
    test('no existing enrollment data at all -> allowed', () {
      final result = checkEnrollmentGuard(isPaid: null, paymentStatus: null);
      expect(result, EnrollmentGuardResult.allowed);
    });

    test(
      'already paid -> blocked as already enrolled, regardless of status',
      () {
        final result = checkEnrollmentGuard(
          isPaid: true,
          paymentStatus: 'pending',
        );
        expect(result, EnrollmentGuardResult.alreadyEnrolled);
      },
    );

    test(
      'status approved but is_paid somehow false -> still blocked as already enrolled',
      () {
        final result = checkEnrollmentGuard(
          isPaid: false,
          paymentStatus: 'approved',
        );
        expect(result, EnrollmentGuardResult.alreadyEnrolled);
      },
    );

    test(
      'status pending -> blocked as payment pending, not allowed to resubmit',
      () {
        final result = checkEnrollmentGuard(
          isPaid: false,
          paymentStatus: 'pending',
        );
        expect(result, EnrollmentGuardResult.paymentPending);
      },
    );

    test('status rejected -> allowed to try again', () {
      final result = checkEnrollmentGuard(
        isPaid: false,
        paymentStatus: 'rejected',
      );
      expect(result, EnrollmentGuardResult.allowed);
    });
  });

  group('enrollmentGuardMessage', () {
    test('allowed has no message', () {
      expect(enrollmentGuardMessage(EnrollmentGuardResult.allowed), isNull);
    });

    test(
      'alreadyEnrolled and paymentPending each have a distinct, non-empty message',
      () {
        final already = enrollmentGuardMessage(
          EnrollmentGuardResult.alreadyEnrolled,
        );
        final pending = enrollmentGuardMessage(
          EnrollmentGuardResult.paymentPending,
        );

        expect(already, isNotEmpty);
        expect(pending, isNotEmpty);
        expect(already, isNot(equals(pending)));
      },
    );
  });
}
