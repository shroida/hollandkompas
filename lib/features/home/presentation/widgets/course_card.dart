import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/home/domain/entities/course.dart';
import 'package:hollandkompas/features/home/presentation/widgets/course_image.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback? onTap;

  const CourseCard({super.key, required this.course, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CourseImage(course: course),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LevelBadge(level: course.level),

                  const SizedBox(height: 12),

                  Text(
                    course.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    course.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.subtitleColor(context),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      const Icon(
                        Icons.menu_book_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),

                      const SizedBox(width: 7),

                      Text(
                        'Dutch course',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.subtitleColor(context),
                        ),
                      ),

                      const Spacer(),

                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
