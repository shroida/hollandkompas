import 'package:flutter/material.dart';

class DashboardLoading extends StatelessWidget {
  const DashboardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          _LoadingHeader(),
          SizedBox(height: 32),
          _LoadingGrid(),
          SizedBox(height: 32),
          _LoadingTable(),
        ],
      ),
    );
  }
}

class _LoadingHeader extends StatelessWidget {
  const _LoadingHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ShimmerBox(width: 220, height: 28),
        Spacer(),
        _ShimmerBox(width: 120, height: 40),
      ],
    );
  }
}

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.7,
      ),
      itemBuilder: (_, _) {
        return const _ShimmerBox();
      },
    );
  }
}

class _LoadingTable extends StatelessWidget {
  const _LoadingTable();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        5,
        (index) => const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: _ShimmerBox(height: 65),
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatefulWidget {
  final double? width;
  final double height;

  const _ShimmerBox({this.width, this.height = 120});

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    final begin = dark ? Colors.grey.shade800 : Colors.grey.shade300;
    final end = dark ? Colors.grey.shade700 : Colors.grey.shade100;

    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Color.lerp(begin, end, controller.value),
          ),
        );
      },
    );
  }
}
