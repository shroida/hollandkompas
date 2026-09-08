import 'package:flutter/material.dart';

class DutchFlagBar extends StatelessWidget {
  final Alignment alignment;

  const DutchFlagBar({super.key, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: const SizedBox(
        height: 8,
        child: Row(
          children: [
            Expanded(child: ColoredBox(color: Color(0xFFAE1C28))),
            Expanded(child: ColoredBox(color: Colors.white)),
            Expanded(child: ColoredBox(color: Color(0xFF21468B))),
          ],
        ),
      ),
    );
  }
}
