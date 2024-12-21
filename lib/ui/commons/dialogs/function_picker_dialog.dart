import 'package:flutter/material.dart';

import '../../../data/models/ai_function.dart';
import 'data_picker_dialog.dart';

class FunctionPickerDialog extends StatefulWidget {
  final Function(AIFunction) onChanged;

  const FunctionPickerDialog({super.key, required this.onChanged});

  @override
  State<FunctionPickerDialog> createState() => _StatePickerDialogState();
}

class _StatePickerDialogState extends State<FunctionPickerDialog> {
  final List<AIFunction> _functions = AIFunction.values;

  List<AIFunction> _filteredFunctions = [];

  @override
  Widget build(BuildContext context) {
    return DataPickerDialog<AIFunction>(
      onChanged: widget.onChanged,
      data: _filteredFunctions,
      itemBuilder: (function) => Text(function.name),
      onChangedSearch: (value) {
        setState(() {
          _filteredFunctions = _functions
              .where(
                (function) => function.name.toLowerCase().contains(
                      value.toLowerCase(),
                    ),
              )
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
