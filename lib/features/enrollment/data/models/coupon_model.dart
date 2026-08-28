import '../../domain/entities/coupon.dart';

class CouponModel extends Coupon {
  const CouponModel({
    required super.code,
    required super.percentage,
    required super.isActive,
    super.expiresAt,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      code: json['code'] as String,
      percentage: (json['percentage'] as num).toDouble(),
      isActive: json['is_active'] as bool,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
    );
  }
}
