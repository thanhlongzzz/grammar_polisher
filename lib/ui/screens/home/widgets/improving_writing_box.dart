import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../data/models/improve_writing_result.dart';

class ImprovingWritingBox extends StatelessWidget {
  final ImproveWritingResult result;

  const ImprovingWritingBox({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final stepByStepAdvice = result.diff.stepByStepAdvice.replaceAll('\n', "<br>").trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Html(
          data: "<b>Your text:</b> ${result.diff.newText1}",
        ),
        Html(
          data: "<b>Feedback: </b> ${result.diff.newText2}",
        ),
        Html(
          data: "<b>Your text has been improved by ${result.percentage}%</b>",
        ),
        Html(
          data: "<b>Steps to improve: </b> <br> ${stepByStepAdvice.isNotEmpty ? stepByStepAdvice : "No steps to improve"}",
        ),
      ],
    );
  }
}
