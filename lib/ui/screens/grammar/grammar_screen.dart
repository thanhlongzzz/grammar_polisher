import 'package:flutter/material.dart';

import '../../commons/base_page.dart';

class GrammarScreen extends StatelessWidget {
  const GrammarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Grammar",
      child: Column(
        children: [
          const Text("Grammar"),
        ],
      ),
    );
  }
}
