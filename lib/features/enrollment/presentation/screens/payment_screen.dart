import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

              _CourseSummary(title: widget.courseTitle, price: widget.price),

              const SizedBox(height: 24),

              Text(
                'Pay with InstaPay',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _InstaPayCard(account: instaPayAccount),

              const SizedBox(height: 24),

              const _PaymentInstructions(),

              const SizedBox(height: 24),

              Text(
                'Payment receipt',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              _ReceiptPicker(receipt: receipt, onTap: pickReceipt),

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

class _InstaPayCard extends StatelessWidget {
  final String account;

  const _InstaPayCard({required this.account});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.account_balance_wallet_outlined, size: 42),

            const SizedBox(height: 12),

            Text(
              'InstaPay',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            SelectableText(
              account,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () {
                // Clipboard.setData(...)
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copy Account'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptPicker extends StatelessWidget {
  final File? receipt;
  final VoidCallback onTap;

  const _ReceiptPicker({required this.receipt, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (receipt == null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_upload_outlined, size: 40),
              SizedBox(height: 8),
              Text('Upload Receipt'),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.file(
        receipt!,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _CourseSummary extends StatelessWidget {
  final String title;
  final double price;

  const _CourseSummary({required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const Icon(Icons.school_outlined, size: 40),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Course enrollment',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            Text(
              '${price.toStringAsFixed(0)} EGP',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentInstructions extends StatelessWidget {
  const _PaymentInstructions();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'How to pay',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 14),

            _Instruction(number: '1', text: 'Open InstaPay.'),

            _Instruction(number: '2', text: 'Send the exact course amount.'),

            _Instruction(
              number: '3',
              text: 'Take a screenshot of the payment receipt.',
            ),

            _Instruction(
              number: '4',
              text: 'Upload the receipt and submit your enrollment.',
            ),
          ],
        ),
      ),
    );
  }
}

class _Instruction extends StatelessWidget {
  final String number;
  final String text;

  const _Instruction({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 12, child: Text(number)),

          const SizedBox(width: 10),

          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
