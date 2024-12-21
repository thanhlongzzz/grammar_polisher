import 'package:flutter/material.dart';

import '../../commons/base_page.dart';
import '../../commons/dialogs/function_picker_dialog.dart';
import '../../commons/rounded_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFunction = 'Improve Writing';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BasePage(
      title: 'Polisher',
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Write your content here\nWe\'ll polish it for you',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              minLines: 5,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: 'Write your content here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _onShowFunctionDialog,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Text(
                  _selectedFunction,
                  style: textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 16),
            RoundedButton(
              borderRadius: 16,
              onPressed: () {},
              child: Text(
                'Process',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onShowFunctionDialog() {
    showDialog(
      context: context,
      builder: (context) => FunctionPickerDialog(
        onChanged: _onFunctionChanged,
      ),
    );
  }

  _onFunctionChanged(String value) {
    setState(() {
      _selectedFunction = value;
    });
  }
}
