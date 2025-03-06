import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../generated/assets.dart';

class PaywallPage extends StatelessWidget {
  const PaywallPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final spacing = 8.0;
    return Column(
      children: [
        SizedBox(height: 2 * spacing),
        ListTile(
          leading: SvgPicture.asset(Assets.svgTimerPlay, color: colorScheme.primary, width: 24, height: 24),
          title: Text("No Ads", style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface)),
          subtitle: Text("Enjoy our app without any ads"),
        ),
        ListTile(
          leading: Icon(Icons.group, color: colorScheme.primary),
          title: Text("Support anywhere", style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface)),
          subtitle: Text("Get support from our team"),
        ),
        ListTile(
          leading: Icon(Icons.check, color: colorScheme.primary),
          title: Text("Best performance", style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface)),
          subtitle: Text("Our server will prioritize your requests"),
        ),
      ],
    );
  }
}
