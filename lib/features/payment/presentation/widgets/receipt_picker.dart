import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReceiptPicker extends StatelessWidget {
  final XFile? receipt;
  final VoidCallback onTap;

  const ReceiptPicker({super.key, required this.receipt, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (receipt == null) {
      return _UploadReceipt(onTap: onTap);
    }

    return _ReceiptPreview(receipt: receipt!);
  }
}

class _UploadReceipt extends StatelessWidget {
  final VoidCallback onTap;

  const _UploadReceipt({required this.onTap});

  @override
  Widget build(BuildContext context) {
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
}

class _ReceiptPreview extends StatelessWidget {
  final XFile receipt;

  const _ReceiptPreview({required this.receipt});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: FutureBuilder<Uint8List>(
        future: receipt.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              width: double.infinity,
              height: 220,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Container(
              width: double.infinity,
              height: 220,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text('Unable to preview receipt'),
            );
          }

          return Image.memory(
            snapshot.data!,
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
