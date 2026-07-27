import 'package:flutter/material.dart';

class BottomDutchFlag extends StatelessWidget {
  const BottomDutchFlag({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 8,
        child: Row(
          children: [
            Expanded(
              child: ColoredBox(
                color: Color(0xFFAE1C28),
              ),
            ),
            Expanded(
              child: ColoredBox(
                color: Colors.white,
              ),
            ),
            Expanded(
              child: ColoredBox(
                color: Color(0xFF21468B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
