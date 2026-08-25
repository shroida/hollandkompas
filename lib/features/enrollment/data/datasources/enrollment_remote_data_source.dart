import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/coupon_model.dart';

abstract class EnrollmentRemoteDataSource {
  Future<CouponModel?> getCoupon(String code);
}

class EnrollmentRemoteDataSourceImpl implements EnrollmentRemoteDataSource {
  final SupabaseClient supabase;

  EnrollmentRemoteDataSourceImpl({required this.supabase});

  @override
  Future<CouponModel?> getCoupon(String code) async {
    final response = await supabase
        .from('coupons')
        .select('code, percentage, is_active, expires_at')
        .eq('code', code)
        .eq('is_active', true)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return CouponModel.fromJson(response);
  }
}
