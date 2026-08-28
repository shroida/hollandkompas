import '../entities/coupon.dart';
import '../repositories/enrollment_repository.dart';

class ApplyCoupon {
  final EnrollmentRepository repository;

  ApplyCoupon({required this.repository});

  Future<Coupon> call(String code) async {
    final normalizedCode = code.trim().toUpperCase();

    if (normalizedCode.isEmpty) {
      throw Exception('Please enter a coupon code.');
    }

    final coupon = await repository.getCoupon(normalizedCode);

    if (coupon == null) {
      throw Exception('Invalid or inactive coupon.');
    }

    if (coupon.isExpired) {
      throw Exception('This coupon has expired.');
    }

    return coupon;
  }
}
