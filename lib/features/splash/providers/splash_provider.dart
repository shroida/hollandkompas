import 'dart:async';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter/material.dart';
final splashProvider =
    StateNotifierProvider<SplashNotifier, double>((ref) {
  return SplashNotifier();
});

class SplashNotifier extends StateNotifier<double> {
  SplashNotifier() : super(0);

  Timer? _timer;

  void start(VoidCallback onDone) {
    _timer = Timer.periodic(
      const Duration(milliseconds: 60),
      (timer) {
        if (state >= 100) {
          timer.cancel();

          Future.delayed(
            const Duration(milliseconds: 300),
            onDone,
          );
        } else {
          state += 2.5;
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}