import 'package:flutter/material.dart';

import 'data_picker_dialog.dart';

class FunctionPickerDialog extends StatefulWidget {
  final Function(String) onChanged;

  const FunctionPickerDialog({super.key, required this.onChanged});

  @override
  State<FunctionPickerDialog> createState() => _StatePickerDialogState();
}

class _StatePickerDialogState extends State<FunctionPickerDialog> {
  final List<String> _functions = [
    "Improve Writing",
    "Check Grammar",
    "Detect Chat GPT",
    "Check Level",
    "Check Score",
    "Check writing",
    "Check Vocabulary",
  ];

  List<String> _filteredFunctions = [];

  @override
  Widget build(BuildContext context) {
    return DataPickerDialog<String>(
      onChanged: widget.onChanged,
      data: _filteredFunctions,
      itemBuilder: (state) => Text(
        state,
      ),
      onChangedSearch: (value) {
        setState(() {
          _filteredFunctions = _functions
              .where((state) => state.toLowerCase().contains(value.toLowerCase()))
              .toList();
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _filteredFunctions = _functions;
  }
}
