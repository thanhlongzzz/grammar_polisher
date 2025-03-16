import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../generated/assets.dart';
import '../../blocs/iap/iap_bloc.dart';
import '../../commons/ads/banner_ad_widget.dart';
import '../../commons/base_page.dart';
import 'bloc/streak_bloc.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isPremium = context.watch<IapBloc>().state.boughtNoAdsTime != null;
    return BlocBuilder<StreakBloc, StreakState>(
      builder: (context, state) {
        final percent = state.spentTimeToday / StreakBloc.timePerDayNeeded;
        return Stack(
          children: [
            BasePage(
              title: "Streak",
              actions: [
                Text(
                  "Longest: ",
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(Assets.pngFlame, width: 16),
                const SizedBox(width: 2.0),
                Text(
                  state.longestStreak.toString(),
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width * 0.2,
                    child: CircularPercentIndicator(
                      radius: size.width * 0.2,
                      lineWidth: 10.0,
                      circularStrokeCap: CircularStrokeCap.round,
                      percent: percent > 1 ? 1 : percent,
                      center: Image.asset(state.streak != 0 ? Assets.pngFlame : Assets.pngFlameInactive),
                      progressColor: Color(0xFFf5a623),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    state.streak.toString(),
                    style: textTheme.headlineLarge?.copyWith(
                      color: state.streak != 0 ? Color(0xFFf5a623) : colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Streaks",
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Keep up the good work!",
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    "Study at least 5 minutes a day to keep the streak going! Small steps lead to big results. 🚀",
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BannerAdWidget(
                isPremium: isPremium,
              ),
            )
          ],
        );
      },
    );
  }
}
