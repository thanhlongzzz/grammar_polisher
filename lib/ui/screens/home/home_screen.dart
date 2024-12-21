import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/ai_function.dart';
import '../../../data/models/improve_writing_result.dart';
import '../../../utils/app_snack_bar.dart';
import '../../commons/base_page.dart';
import '../../commons/dialogs/function_picker_dialog.dart';
import '../../commons/rounded_button.dart';
import 'bloc/home_bloc.dart';
import 'widgets/improving_writing_box.dart';
import 'widgets/text_field_control_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _textController;
  AIFunction _selectedFunction = AIFunction.improveWriting;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Stack(
          children: [
            BasePage(
              title: 'Home',
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
                      controller: _textController,
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
                    TextFieldControlBox(
                      onCopy: _onCopy,
                      onPaste: _onPaste,
                      onDelete: _onDelete,
                      onMic: _onMic,
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
                          _selectedFunction.name,
                          style: textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    RoundedButton(
                      borderRadius: 16,
                      onPressed: _processContent,
                      child: Text(
                        'Process',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (state.result is ImproveWritingResult) ImprovingWritingBox(result: state.result as ImproveWritingResult),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onShowFunctionDialog() {
    showDialog(
      context: context,
      builder: (context) => FunctionPickerDialog(
        onChanged: _onFunctionChanged,
      ),
    );
  }

  _onFunctionChanged(AIFunction value) {
    setState(() {
      _selectedFunction = value;
    });
  }

  void _processContent() {
    switch (_selectedFunction) {
      case AIFunction.improveWriting:
        context.read<HomeBloc>().add(HomeEvent.improveWriting(_textController.text));
        break;
      default:
        break;
    }
  }

  void _onCopy() async {
    if (_textController.text.isEmpty) {
      return;
    }
    final clipboardData = ClipboardData(text: _textController.text);
    await Clipboard.setData(clipboardData);
  }

  void _onPaste() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null) {
      _textController.text = clipboardData.text ?? '';
    }
  }

  void _onDelete() {
    if (_textController.text.isEmpty) {
      return;
    }
    _textController.clear();
  }

  void _onMic() {

  }
}
