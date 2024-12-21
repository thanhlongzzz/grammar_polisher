import 'package:flutter/material.dart';

import '../../generated/assets.dart';
import 'svg_button.dart';

class AppHeader extends StatelessWidget {
  final String title;

  const AppHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
      child: Stack(
        children: [
          Center(child: Text(title, style: Theme.of(context).textTheme.titleMedium!)),
          Row(
            children: [
              if (Navigator.of(context).canPop())
                SvgButton(
                  svg: Assets.svgClose,
                  onPressed: () => _onClose(context),
                ),
            ],
          ),
        ],
      ),
    );
  }

  _onClose(BuildContext context) {
    Navigator.of(context).pop();
  }
}
