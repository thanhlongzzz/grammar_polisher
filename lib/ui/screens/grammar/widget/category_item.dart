import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/lesson.dart';
import '../../../../generated/assets.dart';
import '../../../../navigation/app_router.dart';
import '../../../blocs/iap/iap_bloc.dart';
import '../../../commons/ads/rewarded_ad_mixin.dart';
import '../bloc/lesson_bloc.dart';

class CategoryItem extends StatefulWidget {
  final int index;
  final Lesson lesson;
  final Function(bool?) onMark;
  final bool isBeta;

  const CategoryItem({
    super.key,
    required this.lesson,
    required this.onMark,
    required this.index,
    this.isBeta = false,
  });

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> with RewardedAdMixin {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isPremium = context.read<IapBloc>().state.boughtNoAdsTime != null;
    return BlocBuilder<LessonBloc, LessonState>(
      builder: (context, state) {
        final isMarked = state.markedLessons[widget.lesson.id] ?? false;
        return MaterialButton(
          elevation: 0.0,
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: isMarked ? colorScheme.secondaryContainer : colorScheme.primaryContainer,
          onPressed: () => widget.isBeta ? null : _onTap(),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.lesson.title,
                          style: textTheme.titleSmall?.copyWith(
                            decoration: isMarked ? TextDecoration.lineThrough : null,
                            color: isMarked
                                ? colorScheme.onSecondaryContainer
                                : colorScheme.onPrimaryContainer.withValues(
                                    alpha: widget.isBeta ? 0.5 : 1,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        if (widget.index >= 3 && !isPremium)
                          SvgPicture.asset(
                            Assets.svgTimerPlay,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                              colorScheme.onPrimaryContainer,
                              BlendMode.srcIn,
                            ),
                          )
                      ],
                    ),
                    if (widget.lesson.subTitle != null)
                      Text(
                        widget.lesson.subTitle!,
                        style: textTheme.bodySmall?.copyWith(
                          decoration: isMarked ? TextDecoration.lineThrough : null,
                          color: isMarked
                              ? colorScheme.onSecondaryContainer
                              : colorScheme.onPrimaryContainer.withValues(
                                  alpha: widget.isBeta ? 0.5 : 1,
                                ),
                        ),
                      ),
                  ],
                ),
              ),
              Checkbox(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                value: state.markedLessons[widget.lesson.id] ?? false,
                onChanged: widget.isBeta ? null : widget.onMark,
              )
            ],
          ),
        );
      },
    );
  }

  @override
  bool get isPremium => context.read<IapBloc>().state.boughtNoAdsTime != null;

  _onTap() {
    final isPremium = context.read<IapBloc>().state.boughtNoAdsTime != null;
    if (!isPremium && widget.index >= 3) {
      showRewardedAd((_, __) {
        context.push(RoutePaths.lesson, extra: {'lesson': widget.lesson});
      });
    } else {
      context.push(RoutePaths.lesson, extra: {'lesson': widget.lesson});
    }
  }
}
