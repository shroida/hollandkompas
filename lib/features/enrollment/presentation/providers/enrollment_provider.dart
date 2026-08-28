import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/enrollment/data/datasources/enrollment_remote_data_source.dart';
import 'package:hollandkompas/features/enrollment/data/repositories/enrollment_repository_impl.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/enrollment.dart';
import 'package:hollandkompas/features/enrollment/domain/repositories/enrollment_repository.dart';
import 'package:hollandkompas/features/enrollment/domain/usecases/apply_coupon.dart';
import 'package:image_picker/image_picker.dart';
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
final createPaymentRequestProvider = Provider<CreatePaymentRequestUseCase>((
  ref,
) {
  return CreatePaymentRequestUseCase(ref.watch(enrollmentRepositoryProvider));
});

class CreatePaymentRequestUseCase {
  final EnrollmentRepository repository;

  CreatePaymentRequestUseCase(this.repository);

  Future<Enrollment> call({
    required String courseId,
    required double originalPrice,
    required double discountPercentage,
    required double discountAmount,
    required double finalPrice,
    required String? couponCode,
    required XFile receipt,
    required String paymentReference,
  }) {
    return repository.createPaymentRequest(
      courseId: courseId,
      originalPrice: originalPrice,
      discountPercentage: discountPercentage,
      discountAmount: discountAmount,
      finalPrice: finalPrice,
      couponCode: couponCode,
      receipt: receipt,
      paymentReference: paymentReference,
    );
  }
}
