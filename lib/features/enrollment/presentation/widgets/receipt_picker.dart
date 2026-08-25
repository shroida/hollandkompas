import 'dart:io';

import 'package:flutter/material.dart';

class ReceiptPicker extends StatelessWidget {
  final File? receipt;
  final VoidCallback onTap;

  const ReceiptPicker({super.key, required this.receipt, required this.onTap});

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
