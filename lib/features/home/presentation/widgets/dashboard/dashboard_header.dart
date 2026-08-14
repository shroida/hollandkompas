import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Admin Dashboard",
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
