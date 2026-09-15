import 'package:flutter/material.dart';

class MyCoursesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyCoursesAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'My Courses',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }
}
