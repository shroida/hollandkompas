import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() =>
      _LevelSelectionScreenState();
}

class _LevelSelectionScreenState
    extends State<LevelSelectionScreen> {
  String selectedLevel = 'A1';

  final levels = [
    ('A1', 'مبتدئ'),
    ('A2', 'أساسي'),
    ('B1', 'متوسط'),
    ('B2', 'متقدم'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
              const SizedBox(height: 20),

                const Text(
                  'اختر مستواك الحالي',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                GridView.builder(
                  shrinkWrap: true,
                  itemCount: levels.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                  ),
                  itemBuilder: (_, index) {
                    final level = levels[index];

                    final selected =
                        selectedLevel == level.$1;

                return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      setState(() {
                        selectedLevel = level.$1;
                      });
                    },
                    child: AnimatedScale(
                      scale: selected ? 1.05 : 1.0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFFFFF4ED)
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFFFF6B00)
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                          boxShadow: [
                            if (selected)
                              BoxShadow(
                                color: const Color(
                                  0xFFFF6B00,
                                ).withValues(alpha: .20),
                                blurRadius: 20,
                                spreadRadius: 2,
                                offset: const Offset(0, 8),
                              ),
                          ],
                        ),
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Column(
                              key: ValueKey(selected),
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                AnimatedOpacity(
                                  opacity: selected ? 1 : 0,
                                  duration:
                                      const Duration(milliseconds: 250),
                                  child: const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFFFF6B00),
                                    size: 18,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  level.$1,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: selected
                                        ? const Color(0xFF0D1117)
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                  ),
                                ),

                                const SizedBox(height: 2),

                                Text(
                                  level.$2,
                                  style: TextStyle(
                                    color: selected
                                        ? const Color(0xFF374151)
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: .7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                  },
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                      onPressed: () {
                      context.go( '/login');
                    },
                    
                    child: const Text(
                      'ابدأ رحلتك 🚀',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}