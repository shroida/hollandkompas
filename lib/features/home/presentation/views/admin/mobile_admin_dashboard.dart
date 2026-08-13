import 'package:flutter/material.dart';

class MobileAdminDashboard extends StatelessWidget {
  const MobileAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            "Admin Dashboard",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}