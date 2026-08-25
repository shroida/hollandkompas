import '../models/coupon_model.dart';

abstract class EnrollmentRemoteDataSource {
  Future<CouponModel?> getCoupon(String code);
}
