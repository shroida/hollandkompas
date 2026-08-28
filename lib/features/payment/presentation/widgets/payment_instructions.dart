import 'package:flutter/material.dart';

class PaymentInstructions extends StatelessWidget {
  const PaymentInstructions({super.key});

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

            Instruction(number: '1', text: 'Open InstaPay.'),

            Instruction(number: '2', text: 'Send the exact course amount.'),

            Instruction(
              number: '3',
              text: 'Take a screenshot of the payment receipt.',
            ),

            Instruction(
              number: '4',
              text: 'Upload the receipt and submit your enrollment.',
            ),
          ],
        ),
      ),
    );
  }
}

class Instruction extends StatelessWidget {
  final String number;
  final String text;

  const Instruction({super.key, required this.number, required this.text});

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
