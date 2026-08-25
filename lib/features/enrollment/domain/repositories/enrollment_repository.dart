import '../entities/coupon.dart';

abstract class EnrollmentRepository {
  Future<Coupon?> getCoupon(String code);
}
