import 'package:flutter/material.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Text(
              '🔵',
              style: TextStyle(fontSize: 18),
            ),
            label: const Text('Google'),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Text(
              '🍎',
              style: TextStyle(fontSize: 18),
            ),
            label: const Text('Apple'),
          ),
        ),
      ],
    );
  }
}