import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

import '../../providers/vocabulary_list_providers.dart';

class CategoryFilterChips extends ConsumerWidget {
  const CategoryFilterChips({super.key, required this.categories});

  final List<String> categories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedVocabularyCategoryProvider);

    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _CategoryItem(
              label: 'كل الموضوعات',
              category: null,
              selected: selected == null,
              onTap: () {
                ref.read(selectedVocabularyCategoryProvider.notifier).set(null);
              },
            );
          }

          final category = categories[index - 1];

          return _CategoryItem(
            label: _categoryLabel(category),
            category: category,
            selected: selected == category,
            onTap: () {
              ref
                  .read(selectedVocabularyCategoryProvider.notifier)
                  .set(category);
            },
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.label,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String? category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final categoryColor = _categoryColor(category);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.borderColor(context),
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.94,
                      end: 1,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Row(
                key: ValueKey('$category-$selected'),
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selected)
                    const Icon(
                      Icons.check_rounded,
                      size: 17,
                      color: Colors.white,
                    )
                  else
                    Icon(
                      category == null
                          ? Icons.apps_rounded
                          : _categoryIcon(category!),
                      size: 17,
                      color: categoryColor,
                    ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? Colors.white
                          : AppColors.textColor(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Color _categoryColor(String? category) {
  switch (category?.toLowerCase()) {
    case 'verb':
      return const Color(0xFF2563EB);

    case 'expression':
      return const Color(0xFF7C3AED);

    case 'phone':
      return const Color(0xFF0891B2);

    case 'grammar':
      return AppColors.secondary;

    case 'location':
      return const Color(0xFF059669);

    case 'food':
      return const Color(0xFFEA580C);

    case 'money':
      return const Color(0xFF16A34A);

    case 'drink':
      return const Color(0xFF0284C7);

    case 'question':
      return const Color(0xFF9333EA);

    case 'pronoun':
      return const Color(0xFFDB2777);

    case 'family':
      return const Color(0xFFE11D48);

    case 'weather':
      return const Color(0xFF0EA5E9);

    case 'time':
      return const Color(0xFF6366F1);

    default:
      return AppColors.primary;
  }
}

IconData _categoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'verb':
      return Icons.directions_run_outlined;

    case 'expression':
      return Icons.chat_bubble_outline;

    case 'phone':
      return Icons.phone_outlined;

    case 'grammar':
      return Icons.menu_book_outlined;

    case 'location':
      return Icons.location_on_outlined;

    case 'food':
      return Icons.restaurant_outlined;

    case 'money':
      return Icons.payments_outlined;

    case 'drink':
      return Icons.local_drink_outlined;

    case 'question':
      return Icons.help_outline;

    case 'pronoun':
      return Icons.person_outline;

    case 'family':
      return Icons.family_restroom_outlined;

    case 'weather':
      return Icons.cloud_outlined;

    case 'time':
      return Icons.access_time;

    default:
      return Icons.category_outlined;
  }
}

String _categoryLabel(String category) {
  switch (category.toLowerCase()) {
    case 'verb':
      return 'أفعال';

    case 'expression':
      return 'تعبيرات';

    case 'phone':
      return 'هاتف';

    case 'grammar':
      return 'قواعد';

    case 'location':
      return 'أماكن';

    case 'food':
      return 'طعام';

    case 'money':
      return 'مال';

    case 'drink':
      return 'مشروبات';

    case 'question':
      return 'أسئلة';

    case 'pronoun':
      return 'ضمائر';

    case 'family':
      return 'العائلة';

    case 'weather':
      return 'الطقس';

    case 'time':
      return 'الوقت';

    default:
      return category;
  }
}
