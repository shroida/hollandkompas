import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class CoursesLoading extends StatelessWidget {
  const CoursesLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}
