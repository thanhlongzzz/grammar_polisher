import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgButton extends StatelessWidget {
  final String svg;
  final double size;
  final VoidCallback? onPressed;
  final Color? color;
  final Color backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;

  const SvgButton({
    super.key,
    required this.svg,
    this.onPressed,
    this.size = 24,
    this.color,
    this.backgroundColor = Colors.transparent,
    this.borderRadius,
    this.padding = const EdgeInsets.all(4),
  });

  @override
  Widget build(BuildContext context) {
    final hideColor = Theme.of(context).colorScheme.onSurface;
    return Material(
      color: onPressed != null ? backgroundColor : hideColor,
      borderRadius: borderRadius ?? BorderRadius.circular(100),
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius ?? BorderRadius.circular(100),
        child: Padding(
          padding: padding,
          child: SvgPicture.asset(
            height: size,
            svg,
            colorFilter: color != null
                ? ColorFilter.mode(
                    color!,
                    BlendMode.srcIn,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}