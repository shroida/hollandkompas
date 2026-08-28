import 'package:flutter/material.dart';

class InstaPayCard extends StatelessWidget {
  final String account;

  const InstaPayCard({super.key, required this.account});

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
                // TODO: Copy account to clipboard
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
