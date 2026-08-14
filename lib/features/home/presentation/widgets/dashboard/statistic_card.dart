import 'package:flutter/material.dart';

class StatisticCard extends StatelessWidget {
  final String title;

  final String value;

  final IconData icon;

  const StatisticCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Row(
          children: [
            Icon(icon, size: 40),

            const SizedBox(width: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(title),

                const SizedBox(height: 8),

                Text(value, style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
