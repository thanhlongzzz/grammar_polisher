import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/lesson.dart';
import '../bloc/lesson_bloc.dart';

class CategoryItem extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;
  final Function(bool?) onMark;
  final bool isBeta;

  const CategoryItem({
    super.key,
    required this.lesson,
    required this.onTap,
    required this.onMark,
    this.isBeta = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<LessonBloc, LessonState>(
      builder: (context, state) {
        final isMarked = state.markedLessons[lesson.id] ?? false;
        return MaterialButton(
          elevation: 0.0,
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: isMarked ? colorScheme.secondaryContainer : colorScheme.primaryContainer,
          onPressed: () => isBeta ? null : onTap(),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: textTheme.titleSmall?.copyWith(
                        decoration: isMarked ? TextDecoration.lineThrough : null,
                        color: isMarked ? colorScheme.onSecondaryContainer : colorScheme.onPrimaryContainer.withValues(
                          alpha: isBeta ? 0.5 : 1,
                        ),
                      ),
                    ),
                    if (lesson.subTitle != null)
                      Text(
                        lesson.subTitle!,
                        style: textTheme.bodySmall?.copyWith(
                          decoration: isMarked ? TextDecoration.lineThrough : null,
                          color: isMarked ? colorScheme.onSecondaryContainer : colorScheme.onPrimaryContainer.withValues(
                            alpha: isBeta ? 0.5 : 1,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Checkbox(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                value: state.markedLessons[lesson.id] ?? false,
                onChanged: isBeta ? null : onMark,
              )
            ],
          ),
        );
      },
    );
  }
}
