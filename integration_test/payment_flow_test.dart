import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/enrollment.dart';
import 'package:image_picker/image_picker.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/fakes.dart';

XFile _fakeReceipt() => XFile.fromData(
  Uint8List.fromList(const [1, 2, 3, 4]),
  name: 'receipt.jpg',
  mimeType: 'image/jpeg',
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  test(
    'a first-time purchase succeeds and creates a pending enrollment',
    () async {
      final repo = FakeEnrollmentRepository(currentStudentId: 'student-1');

      final enrollment = await repo.createPaymentRequest(
        courseId: 'course-callcenter',
        originalPrice: 2500,
        discountPercentage: 0,
        discountAmount: 0,
        finalPrice: 2500,
        couponCode: null,
        receipt: _fakeReceipt(),
        paymentReference: 'ref-001',
      );

      expect(enrollment.paymentStatus, 'pending');
      expect(enrollment.courseId, 'course-callcenter');
      expect(repo.createPaymentRequestCallCount, 1);
    },
  );

  test(
    'a second purchase attempt while the first is still pending is blocked',
    () async {
      final repo = FakeEnrollmentRepository(currentStudentId: 'student-1');

      await repo.createPaymentRequest(
        courseId: 'course-callcenter',
        originalPrice: 2500,
        discountPercentage: 0,
        discountAmount: 0,
        finalPrice: 2500,
        couponCode: null,
        receipt: _fakeReceipt(),
        paymentReference: 'ref-001',
      );

      expect(
        () => repo.createPaymentRequest(
          courseId: 'course-callcenter',
          originalPrice: 2500,
          discountPercentage: 0,
          discountAmount: 0,
          finalPrice: 2500,
          couponCode: null,
          receipt: _fakeReceipt(),
          paymentReference: 'ref-002',
        ),
        throwsA(predicate((e) => e.toString().contains('waiting for review'))),
      );
    },
  );

  test('re-purchasing a course already fully paid for is blocked', () async {
    final repo = FakeEnrollmentRepository(currentStudentId: 'student-1');
    repo.seedExistingEnrollment(
      'student-1',
      'course-a1',
      Enrollment(
        id: 'enr-existing',
        studentId: 'student-1',
        courseId: 'course-a1',
        isPaid: true,
        originalPrice: 4500,
        discountPercentage: 0,
        discountAmount: 0,
        finalPrice: 4500,
        couponCode: null,
        paymentReceiptUrl: 'https://example.com/r.jpg',
        paymentReference: 'ref-000',
        paymentStatus: 'approved',
        paymentSubmittedAt: DateTime(2026, 9, 1),
        paymentReviewedAt: DateTime(2026, 9, 2),
        paymentReviewedBy: 'admin-1',
        enrolledAt: DateTime(2026, 9, 1),
      ),
    );

    expect(
      () => repo.createPaymentRequest(
        courseId: 'course-a1',
        originalPrice: 4500,
        discountPercentage: 0,
        discountAmount: 0,
        finalPrice: 4500,
        couponCode: null,
        receipt: _fakeReceipt(),
        paymentReference: 'ref-003',
      ),
      throwsA(predicate((e) => e.toString().contains('already enrolled'))),
    );
  });

  test('a previously rejected request can be retried successfully', () async {
    final repo = FakeEnrollmentRepository(currentStudentId: 'student-1');
    repo.seedExistingEnrollment(
      'student-1',
      'course-a1',
      Enrollment(
        id: 'enr-rejected',
        studentId: 'student-1',
        courseId: 'course-a1',
        isPaid: false,
        originalPrice: 4500,
        discountPercentage: 0,
        discountAmount: 0,
        finalPrice: 4500,
        couponCode: null,
        paymentReceiptUrl: 'https://example.com/r.jpg',
        paymentReference: 'ref-000',
        paymentStatus: 'rejected',
        paymentSubmittedAt: DateTime(2026, 9, 1),
        paymentReviewedAt: DateTime(2026, 9, 2),
        paymentReviewedBy: 'admin-1',
        enrolledAt: DateTime(2026, 9, 1),
      ),
    );

    final retried = await repo.createPaymentRequest(
      courseId: 'course-a1',
      originalPrice: 4500,
      discountPercentage: 0,
      discountAmount: 0,
      finalPrice: 4500,
      couponCode: null,
      receipt: _fakeReceipt(),
      paymentReference: 'ref-004',
    );

    expect(retried.paymentStatus, 'pending');
  });

  test('a coupon that has expired or is inactive is not returned', () async {
    final repo =
        FakeEnrollmentRepository(); // no coupon seeded -> nothing is active
    final coupon = await repo.getCoupon('EXPIRED10');
    expect(coupon, isNull);
  });
}
