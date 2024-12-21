import 'package:flutter/material.dart';

import '../../../../generated/assets.dart';
import '../../../commons/svg_button.dart';

class TextFieldControlBox extends StatelessWidget {
  final VoidCallback? onCopy;
  final VoidCallback? onPaste;
  final VoidCallback? onDelete;
  final VoidCallback? onMic;

  const TextFieldControlBox({
    super.key,
    this.onCopy,
    this.onPaste,
    this.onDelete,
    this.onMic,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SvgButton(
          svg: Assets.svgCopy,
          onPressed: onCopy,
        ),
        const SizedBox(width: 16),
        SvgButton(
          svg: Assets.svgPaste,
          onPressed: onPaste,
        ),
        const SizedBox(width: 16),
        SvgButton(
          svg: Assets.svgDelete,
          onPressed: onDelete,
        ),
        const SizedBox(width: 16),
        SvgButton(
          svg: Assets.svgMic,
          onPressed: onMic,
        ),
      ],
    );
  }
}
