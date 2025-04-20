import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../configs/di.dart';
import '../../../../generated/assets.dart';
import '../../../commons/svg_button.dart';

class Phonetic extends StatefulWidget {
  final String phonetic;
  final String phoneticText;
  final Color backgroundColor;

  const Phonetic({
    super.key,
    required this.phonetic,
    required this.phoneticText,
    this.backgroundColor = Colors.transparent,
  });

  @override
  State<Phonetic> createState() => _PhoneticState();
}

class _PhoneticState extends State<Phonetic> {
  final _player = DI().sl<AudioPlayer>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgButton(
          svg: Assets.svgVolumeUp,
          backgroundColor: widget.backgroundColor,
          color: Colors.white,
          size: 32, // Tăng kích thước từ 24 lên 32
          padding: const EdgeInsets.all(8), // Thêm padding để tăng vùng chạm
          onPressed: _playSound,
        ),
        const SizedBox(width: 8),
        SelectableText(
          widget.phoneticText,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  void _playSound() async {
    try {
      await _player.setUrl(widget.phonetic);
      await _player.play();
    } catch (e) {
      debugPrint('skip');
    }
  }
}
