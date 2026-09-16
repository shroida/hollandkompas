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
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _buildChip(
            context: context,
            ref: ref,
            label: 'كل الموضوعات',
            category: null,
            selected: selected,
          ),

          for (final category in categories)
            _buildChip(
              context: context,
              ref: ref,
              label: _categoryLabel(category),
              category: category,
              selected: selected,
            ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required WidgetRef ref,
    required String label,
    required String? category,
    required String? selected,
  }) {
    final isSelected = selected == category;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: FilterChip(
        avatar: category == null
            ? null
            : Icon(
                _categoryIcon(category),
                size: 16,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          ref.read(selectedVocabularyCategoryProvider.notifier).set(category);
        },
        selectedColor: AppColors.secondary,
        backgroundColor: AppColors.muted,
        labelStyle: TextStyle(
          fontFamily: 'Cairo',
          color: isSelected ? Colors.white : AppColors.foreground,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
      ),
    );
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
