import 'package:flutter_test/flutter_test.dart';
import 'package:hollandkompas/features/enrollment/data/models/enrollment_model.dart';

import '../../helpers/fixtures.dart';

void main() {
  group('EnrollmentModel.fromMap', () {
    test('maps a complete row correctly', () {
      final model = EnrollmentModel.fromMap(enrollmentJson(
        isPaid: true,
        paymentStatus: 'approved',
      ));

      expect(model.isPaid, true);
      expect(model.paymentStatus, 'approved');
      expect(model.originalPrice, 4500);
    });

    test('falls back to safe defaults when numeric/bool fields are missing', () {
      final row = <String, dynamic>{'id': 'e1'};
      final model = EnrollmentModel.fromMap(row);

      expect(model.studentId, '');
      expect(model.courseId, '');
      expect(model.isPaid, false);
      expect(model.originalPrice, 0);
      expect(model.discountPercentage, 0);
      expect(model.discountAmount, 0);
      expect(model.finalPrice, 0);
      expect(model.paymentStatus, 'pending');
    });

    test('unparseable or missing dates become null instead of throwing', () {
      final model = EnrollmentModel.fromMap(enrollmentJson(
        paymentSubmittedAt: 'not-a-real-date',
        enrolledAt: null,
      ));

      expect(model.paymentSubmittedAt, isNull);
      expect(model.enrolledAt, isNull);
    });

    test('a valid ISO date string parses correctly', () {
      final model = EnrollmentModel.fromMap(enrollmentJson(
        enrolledAt: '2026-09-17T10:00:00.000Z',
      ));

      expect(model.enrolledAt, DateTime.parse('2026-09-17T10:00:00.000Z'));
    });
  });

  group('EnrollmentModel.toMap', () {
    test('round-trips through fromMap/toMap without losing data', () {
      final original = enrollmentJson(couponCode: 'WELCOME10');
      final model = EnrollmentModel.fromMap(original);
      final map = model.toMap();

      expect(map['id'], original['id']);
      expect(map['coupon_code'], 'WELCOME10');
      expect(map['payment_status'], original['payment_status']);
      expect(map['is_paid'], original['is_paid']);
    });
  });
}
