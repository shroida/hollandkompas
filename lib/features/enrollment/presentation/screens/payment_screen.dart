import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/enrollment/presentation/widgets/course_summary.dart';
import 'package:hollandkompas/features/enrollment/presentation/widgets/instapay_card.dart';
import 'package:hollandkompas/features/enrollment/presentation/widgets/payment_instructions.dart';
import 'package:hollandkompas/features/enrollment/presentation/widgets/receipt_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final String courseId;
  final String courseTitle;
  final double price;

  const PaymentScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.price,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final referenceController = TextEditingController();
  final couponController = TextEditingController();

  File? receipt;

  bool isSubmitting = false;
  bool isApplyingCoupon = false;

  double? discountPercentage;
  double finalPrice = 0;

  String? couponMessage;

  static const instaPayAccount = '@hollandkompas';

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();

    finalPrice = widget.price;
  }

  @override
  void dispose() {
    referenceController.dispose();
    couponController.dispose();
    super.dispose();
  }

  // ============================================================
  // PICK RECEIPT
  // ============================================================

  Future<void> pickReceipt() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    setState(() {
      receipt = File(image.path);
    });
  }

  // ============================================================
  // APPLY COUPON
  // ============================================================

  Future<void> applyCoupon() async {
    final code = couponController.text.trim().toUpperCase();

    if (code.isEmpty) {
      setState(() {
        couponMessage = 'Please enter a coupon code.';
        discountPercentage = null;
        finalPrice = widget.price;
      });

      return;
    }

    setState(() {
      isApplyingCoupon = true;
      couponMessage = null;
    });

    try {
      final response = await supabase
          .from('coupons')
          .select('code, percentage, is_active, expires_at')
          .eq('code', code)
          .eq('is_active', true)
          .maybeSingle();

      if (response == null) {
        setState(() {
          discountPercentage = null;
          finalPrice = widget.price;
          couponMessage = 'Invalid or inactive coupon.';
        });

        return;
      }

      final expiresAt = response['expires_at'];

      if (expiresAt != null) {
        final expirationDate = DateTime.tryParse(expiresAt.toString());

        if (expirationDate != null && expirationDate.isBefore(DateTime.now())) {
          setState(() {
            discountPercentage = null;
            finalPrice = widget.price;
            couponMessage = 'This coupon has expired.';
          });

          return;
        }
      }

      // ----------------------------------------------------------
      // Get percentage
      // ----------------------------------------------------------

      final percentage = (response['percentage'] as num).toDouble();

      // ----------------------------------------------------------
      // Calculate discount
      // ----------------------------------------------------------

      final discountAmount = widget.price * (percentage / 100);

      final calculatedFinalPrice = widget.price - discountAmount;

      setState(() {
        discountPercentage = percentage;
        finalPrice = calculatedFinalPrice;
        couponMessage = 'Coupon applied successfully.';
      });
    } catch (e) {
      setState(() {
        discountPercentage = null;
        finalPrice = widget.price;
        couponMessage = 'Failed to apply coupon. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isApplyingCoupon = false;
        });
      }
    }
  }

  // ============================================================
  // REMOVE COUPON
  // ============================================================

  void removeCoupon() {
    couponController.clear();

    setState(() {
      discountPercentage = null;
      finalPrice = widget.price;
      couponMessage = null;
    });
  }

  // ============================================================
  // SUBMIT ENROLLMENT
  // ============================================================

  Future<void> submitEnrollment() async {
    if (receipt == null) {
      _showMessage('Please upload your payment receipt.');
      return;
    }

    if (referenceController.text.trim().isEmpty) {
      _showMessage('Please enter the transaction reference.');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      // ==========================================================
      // TODO:
      // 1. Upload receipt to Supabase Storage
      //
      // 2. Create enrollment
      //
      //    is_paid = false
      //    status = pending
      //
      // 3. Save receipt URL
      //
      // 4. Save payment reference
      //
      // 5. Save coupon information
      //
      //    original_price
      //    discount_percentage
      //    discount_amount
      //    final_price
      //    coupon_code
      //
      // ==========================================================

      /*
      await ref
          .read(enrollmentProvider.notifier)
          .createEnrollment(
            courseId: widget.courseId,
            originalPrice: widget.price,
            discountPercentage: discountPercentage,
            finalPrice: finalPrice,
            couponCode: discountPercentage != null
                ? couponController.text.trim().toUpperCase()
                : null,
            receipt: receipt!,
            reference: referenceController.text.trim(),
          );
      */

      if (!mounted) return;

      _showMessage(
        'Enrollment request submitted. Your payment will be reviewed.',
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  // ============================================================
  // SHOW MESSAGE
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final hasCoupon = discountPercentage != null;

    final discountAmount = hasCoupon ? widget.price - finalPrice : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // HEADER
              // ==================================================
              Text(
                'Complete your enrollment',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // COURSE
              // ==================================================
              CourseSummary(title: widget.courseTitle, price: widget.price),

              const SizedBox(height: 24),

              // ==================================================
              // COUPON
              // ==================================================
              Text(
                'Have a coupon?',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: couponController,
                      enabled: !hasCoupon,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: 'Enter coupon code',
                        prefixIcon: const Icon(Icons.local_offer_outlined),
                        border: const OutlineInputBorder(),
                        suffixIcon: hasCoupon
                            ? IconButton(
                                onPressed: removeCoupon,
                                icon: const Icon(Icons.close),
                              )
                            : null,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isApplyingCoupon || hasCoupon
                          ? null
                          : applyCoupon,
                      child: isApplyingCoupon
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Apply'),
                    ),
                  ),
                ],
              ),

              // ==================================================
              // COUPON MESSAGE
              // ==================================================
              if (couponMessage != null) ...[
                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(
                      hasCoupon
                          ? Icons.check_circle_outline
                          : Icons.error_outline,
                      size: 18,
                      color: hasCoupon ? Colors.green : Colors.red,
                    ),

                    const SizedBox(width: 6),

                    Expanded(
                      child: Text(
                        couponMessage!,
                        style: TextStyle(
                          color: hasCoupon ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 20),

              // ==================================================
              // PRICE SUMMARY
              // ==================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Column(
                  children: [
                    // Original price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Original price',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Text(
                          '${widget.price.toStringAsFixed(2)} EGP',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    // Discount
                    if (hasCoupon) ...[
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Discount', style: theme.textTheme.bodyLarge),
                          Text(
                            '-${discountAmount.toStringAsFixed(2)} EGP',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Coupon', style: theme.textTheme.bodyMedium),
                          Text(
                            '${discountPercentage!.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),

                    // Final price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${finalPrice.toStringAsFixed(2)} EGP',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // PAYMENT METHOD
              // ==================================================
              Text(
                'Pay with InstaPay',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const InstaPayCard(account: instaPayAccount),

              const SizedBox(height: 24),

              const PaymentInstructions(),

              const SizedBox(height: 24),

              // ==================================================
              // RECEIPT
              // ==================================================
              Text(
                'Payment receipt',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              ReceiptPicker(receipt: receipt, onTap: pickReceipt),

              const SizedBox(height: 20),

              // ==================================================
              // TRANSACTION REFERENCE
              // ==================================================
              TextField(
                controller: referenceController,
                decoration: const InputDecoration(
                  labelText: 'Transaction reference',
                  hintText: 'Enter transaction reference',
                  prefixIcon: Icon(Icons.receipt_long_outlined),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              // ==================================================
              // SUBMIT
              // ==================================================
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : submitEnrollment,
                  child: isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Submit Enrollment'),
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // FOOTER
              // ==================================================
              Center(
                child: Text(
                  'Your payment will be reviewed by an administrator.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
