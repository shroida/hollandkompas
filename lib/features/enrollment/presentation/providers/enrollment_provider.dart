import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/enrollment/data/datasources/enrollment_remote_data_source.dart';
import 'package:hollandkompas/features/enrollment/data/repositories/enrollment_repository_impl.dart';
import 'package:hollandkompas/features/enrollment/domain/repositories/enrollment_repository.dart';
import 'package:hollandkompas/features/enrollment/domain/usecases/apply_coupon.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final enrollmentRemoteDataSourceProvider = Provider<EnrollmentRemoteDataSource>(
  (ref) {
    return EnrollmentRemoteDataSourceImpl(supabase: Supabase.instance.client);
  },
);

final enrollmentRepositoryProvider = Provider<EnrollmentRepository>((ref) {
  return EnrollmentRepositoryImpl(
    remoteDataSource: ref.read(enrollmentRemoteDataSourceProvider),
  );
});

final applyCouponProvider = Provider<ApplyCoupon>((ref) {
  return ApplyCoupon(repository: ref.read(enrollmentRepositoryProvider));
});
