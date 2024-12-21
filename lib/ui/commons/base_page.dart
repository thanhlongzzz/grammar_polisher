import 'package:flutter/material.dart';

import 'app_header.dart';

class BasePage extends StatelessWidget {
  final Widget child;
  final String title;
  final EdgeInsets padding;

  const BasePage({
    super.key,
    required this.child,
    required this.title,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: SafeArea(
        child: Column(
          children: [
            AppHeader(title: title),
            Expanded(
              child: Padding(
                padding: padding,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
