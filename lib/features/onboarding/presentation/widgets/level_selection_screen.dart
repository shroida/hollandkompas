import 'package:flutter/material.dart';

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
                const Text(
                  '🎯',
                  style: TextStyle(fontSize: 70),
                ),

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
                      onTap: () {
                        setState(() {
                          selectedLevel =
                              level.$1;
                        });
                      },
                      child: Card(
                        color: selected
                            ? const Color(
                                0xFFFFF4ED,
                              )
                            : null,
                        child: Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                level.$1,
                                style:
                                    const TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              Text(level.$2),
                            ],
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
                    onPressed: () {},
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