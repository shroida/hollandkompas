import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  const DotsIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration:
              const Duration(milliseconds: 300),
          margin:
              const EdgeInsets.symmetric(
            horizontal: 4,
          ),
          width:
              currentIndex == index
                  ? 24
                  : 8,
          height: 8,
          decoration: BoxDecoration(
            color:
                currentIndex == index
                    ? const Color(
                      0xFFFF6B00,
                    )
                    : Colors.grey,
            borderRadius:
                BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}