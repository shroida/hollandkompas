import 'package:flutter_test/flutter_test.dart';
import 'package:hollandkompas/features/enrollment/data/models/coupon_model.dart';

import '../../helpers/fixtures.dart';

void main() {
  group('CouponModel.fromJson', () {
    test('maps an active coupon with no expiry', () {
      final coupon = CouponModel.fromJson(couponJson());

      expect(coupon.code, 'WELCOME10');
      expect(coupon.percentage, 10);
      expect(coupon.isActive, true);
      expect(coupon.expiresAt, isNull);
    });

    test('parses a real expiry date when present', () {
      final coupon = CouponModel.fromJson(
        couponJson(expiresAt: '2026-12-31T23:59:59.000Z'),
      );

      expect(coupon.expiresAt, DateTime.parse('2026-12-31T23:59:59.000Z'));
    });

    test('an inactive coupon still parses, with isActive false', () {
      final coupon = CouponModel.fromJson(couponJson(isActive: false));

      expect(coupon.isActive, false);
    });
  });
}
