import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  File? receipt;
  bool isSubmitting = false;

  static const instaPayAccount = '@hollandkompas';

  @override
  void dispose() {
    referenceController.dispose();
    super.dispose();
  }

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
      // 1. Upload receipt to Supabase Storage
      //
      // 2. Create enrollment:
      //
      // is_paid = false
      // status = pending
      //
      // 3. Save receipt URL
      //
      // 4. Save payment reference

      // await ref.read(enrollmentProvider.notifier).createEnrollment(...);

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
                'Pay with InstaPay',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              InstaPayCard(account: instaPayAccount),

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
                ),
              ),

              const SizedBox(height: 24),

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
            ],
          ),
        ),
      ),
    );
  }
}
