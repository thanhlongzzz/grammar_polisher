import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/ai_function.dart';
import '../../../data/models/check_grammar_result.dart';
import '../../../data/models/check_level_result.dart';
import '../../../data/models/check_score_result.dart';
import '../../../data/models/check_writing_result.dart';
import '../../../data/models/detect_gpt_result.dart';
import '../../../data/models/improve_writing_result.dart';
import '../../../data/models/score_type.dart';
import '../../../generated/assets.dart';
import '../../../utils/ads_tools.dart';
import '../../../utils/app_snack_bar.dart';
import '../../commons/banner_ads.dart';
import '../../commons/base_page.dart';
import '../../commons/dialogs/function_picker_dialog.dart';
import '../../commons/rounded_button.dart';
import 'bloc/home_bloc.dart';
import 'widgets/check_grammar_box.dart';
import 'widgets/check_level_box.dart';
import 'widgets/check_score_box.dart';
import 'widgets/check_writing_box.dart';
import 'widgets/detect_gpt_box.dart';
import 'widgets/improving_writing_box.dart';
import 'widgets/score_type_picker.dart';
import 'widgets/text_field_control_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _textController;
  late final FocusNode _textFocusNode;
  AIFunction _selectedFunction = AIFunction.improveWriting;
  final ScoreType _selectedScoreType = ScoreType.opinion;
  int _count = 0;

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) => current.result != previous.result,
      listener: (context, state) {
        _count++;
        if (_count % 2 == 0) {
          _count = 0;
          AdsTools.requestNewInterstitial();
        }
      },
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.pngImg,
              width: double.infinity,
              fit: BoxFit.contain,
              height: 200,
            ),
            const SizedBox(height: 16),
            Text(
              'Thank you for using Grammar AI.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              constraints: BoxConstraints(
                maxWidth: 600,
              ),
              child: Text(
                'We are very sorry to announce that this feature has been discontinued and will be removed in the next update. '
                    'We will be back after improving and refining this feature—it will soon reappear in a new app called \'Nibbles\'. '
                    'We are very sorry for the inconvenience and thank you for your understanding.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
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
    _textFocusNode.unfocus();
    if (_textController.text.isEmpty) {
      AppSnackBar.showError(context, 'Please write some content');
      return;
    }
    final content = _textController.text;
    switch (_selectedFunction) {
      case AIFunction.improveWriting:
        context.read<HomeBloc>().add(HomeEvent.improveWriting(content));
        break;
      case AIFunction.checkGrammar:
        context.read<HomeBloc>().add(HomeEvent.checkGrammar(content));
        break;
      case AIFunction.detectChatGPT:
        context.read<HomeBloc>().add(HomeEvent.detectGpt(content));
        break;
      case AIFunction.checkLevel:
        context.read<HomeBloc>().add(HomeEvent.checkLevel(content));
        break;
      case AIFunction.checkScore:
        context.read<HomeBloc>().add(HomeEvent.checkScore(text: content, type: _selectedScoreType.code));
        break;
      case AIFunction.checkWriting:
        context.read<HomeBloc>().add(HomeEvent.checkWriting(content));
        break;
    }
  }
}
