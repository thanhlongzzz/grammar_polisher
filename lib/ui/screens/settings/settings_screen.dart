import 'package:flutter/material.dart';

import '../../commons/base_page.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Settings',
      child: Center(
        child: TextButton(onPressed: () {
        }, child: const Text('Go back')),
      )
    );
  }
}
