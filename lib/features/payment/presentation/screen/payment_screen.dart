import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/coupon.dart';
import 'package:hollandkompas/features/enrollment/presentation/providers/enrollment_provider.dart';
import 'package:hollandkompas/features/enrollment/presentation/widgets/course_summary.dart';
import 'package:hollandkompas/features/enrollment/presentation/widgets/instapay_card.dart';
import 'package:hollandkompas/features/enrollment/presentation/widgets/payment_instructions.dart';
import 'package:hollandkompas/features/enrollment/presentation/widgets/receipt_picker.dart';
import 'package:image_picker/image_picker.dart';

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

  XFile? receipt;

  Coupon? appliedCoupon;

  bool isSubmitting = false;
  bool isApplyingCoupon = false;

  String? couponMessage;

  static const instaPayAccount = '@hollandkompas';

  bool get hasCoupon => appliedCoupon != null;

  double get discountPercentage {
    return appliedCoupon?.percentage ?? 0;
  }

  double get discountAmount {
    if (appliedCoupon == null) {
      return 0;
    }

    return appliedCoupon!.calculateDiscount(widget.price);
  }

  double get finalPrice {
    if (appliedCoupon == null) {
      return widget.price;
    }

    return appliedCoupon!.calculateFinalPrice(widget.price);
  }

  @override
  void dispose() {
    referenceController.dispose();
    couponController.dispose();
    super.dispose();
  }

  Future<void> pickReceipt() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) {
      return;
    }

    setState(() {
      receipt = image;
    });
  }

  Future<void> applyCoupon() async {
    final code = couponController.text.trim();

    if (code.isEmpty) {
      setState(() {
        couponMessage = 'Please enter a coupon code.';
        appliedCoupon = null;
      });

      return;
    }

    setState(() {
      isApplyingCoupon = true;
      couponMessage = null;
    });

    try {
      final coupon = await ref.read(applyCouponProvider).call(code);

      if (!mounted) {
        return;
      }

      setState(() {
        appliedCoupon = coupon;
        couponMessage = 'Coupon applied successfully.';
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        appliedCoupon = null;
        couponMessage = _cleanErrorMessage(e);
      });
    } finally {
      if (mounted) {
        setState(() {
          isApplyingCoupon = false;
        });
      }
    }
  }

  void removeCoupon() {
    couponController.clear();

    setState(() {
      appliedCoupon = null;
      couponMessage = null;
    });
  }

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
      /*
      await ref
          .read(createEnrollmentProvider)
          .call(
            courseId: widget.courseId,
            originalPrice: widget.price,
            discountPercentage: appliedCoupon?.percentage,
            discountAmount: discountAmount,
            finalPrice: finalPrice,
            couponCode: appliedCoupon?.code,
            receipt: receipt!,
            reference: referenceController.text.trim(),
          );
      */

      if (!mounted) {
        return;
      }

      _showMessage(
        'Enrollment request submitted. '
        'Your payment will be reviewed.',
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  String _cleanErrorMessage(Object error) {
    final message = error.toString();

    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }

    return message;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Complete your enrollment',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              CourseSummary(title: widget.courseTitle, price: widget.price),

              const SizedBox(height: 24),

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
                    _PriceRow(
                      label: 'Original price',
                      value: '${widget.price.toStringAsFixed(2)} EGP',
                    ),

                    if (hasCoupon) ...[
                      const SizedBox(height: 12),

                      _PriceRow(
                        label: 'Discount',
                        value: '-${discountAmount.toStringAsFixed(2)} EGP',
                        valueColor: Colors.green,
                      ),

                      const SizedBox(height: 8),

                      _PriceRow(
                        label: 'Coupon',
                        value: '${discountPercentage.toStringAsFixed(0)}%',
                        valueColor: Colors.green,
                      ),
                    ],

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),

                    _PriceRow(
                      label: 'Total',
                      value: '${finalPrice.toStringAsFixed(2)} EGP',
                      labelStyle: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      valueStyle: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

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

              Text(
                'Payment receipt',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              ReceiptPicker(receipt: receipt, onTap: pickReceipt),

              const SizedBox(height: 20),

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

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const _PriceRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle ?? Theme.of(context).textTheme.bodyLarge),
        Text(
          value,
          style:
              valueStyle ??
              Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
        ),
      ],
    );
  }
}
