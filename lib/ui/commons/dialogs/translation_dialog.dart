import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/extra_translation.dart';
import '../../blocs/translate/translate_cubit.dart';

class DialogTools {
  const DialogTools._();

  static void showTranslateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          insetPadding: EdgeInsets.zero,
          shadowColor: Colors.transparent,
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: TranslateDialog(),
        );
      },
    );
  }

  static void showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Exit"),
          content: const Text("Are you sure you want to exit?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text("Exit"),
            ),
          ],
        );
      },
    );
  }
}

class TranslateDialog extends StatefulWidget {
  const TranslateDialog({super.key});

  @override
  State<TranslateDialog> createState() => _TranslateDialogState();
}

class _TranslateDialogState extends State<TranslateDialog> {
  late TextEditingController _sourceController;
  late TextEditingController _targetController;
  bool _showAllExtraTranslations = false;
  late ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<TranslateCubit, TranslateState>(
      listener: (context, state) {
        _targetController.text = state.translateSnapshot?.content ?? "";
        if (state.errorMessage != null) {
          _targetController.text = state.errorMessage!;
        }
      },
      builder: (context, state) {
        List<ExtraTranslation> extraTranslations = state.translateSnapshot?.moreTranslations ?? [];
        return SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: () {}, icon: const Icon(Icons.translate)),
                        Text("Translate", style: Theme.of(context).textTheme.bodyLarge),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close))
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.titleSmall,
                        children: [
                          const TextSpan(text: "Source: "),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Text(
                              state.sourceLanguage == 'en' ? 'English' : 'Japanese',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _sourceController,
                            onChanged: (value) {
                              _translate(value);
                            },
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                            decoration: InputDecoration(
                              hintText: "Type your translation here",
                              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary.withAlpha(150)),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        if (_sourceController.text.isNotEmpty)
                          IconButton(
                            onPressed: _onDelete,
                            icon: Icon(
                              Icons.delete_outline,
                              color: Theme.of(context).colorScheme.primary,
                              size: 16,
                            ),
                          )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Theme.of(context).colorScheme.primary.withAlpha(100),
                            ),
                          ),
                          IconButton(onPressed: _onSwitch, icon: Icon(Icons.swap_vert, color: Theme.of(context).colorScheme.primary)),
                          Expanded(
                            child: Divider(
                              color: Theme.of(context).colorScheme.primary.withAlpha(100),
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.titleSmall,
                        children: [
                          const TextSpan(text: "Target: "),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Text(
                              state.targetLanguage == 'en' ? 'English' : 'Japanese',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            enabled: false,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                            controller: _targetController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        if (state.translateSnapshot != null && state.translateSnapshot!.type != null)
                          FilterChip(
                            label: Text(state.translateSnapshot!.type!),
                            onSelected: (value) {},
                            selected: true,
                            showCheckmark: false,
                          ),
                        IconButton(
                          onPressed: _onCopy,
                          icon: Icon(
                            Icons.copy,
                            color: Theme.of(context).colorScheme.primary,
                            size: 16,
                          ),
                        )
                      ],
                    ),
                    if (state.translateSnapshot?.spelling != null) Text(state.translateSnapshot!.spelling!, style: Theme.of(context).textTheme.bodyMedium)
                  ],
                ),
              ),
              if (extraTranslations.isNotEmpty)
                Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Text("More translations (${extraTranslations.length})", style: Theme.of(context).textTheme.titleSmall),
                              const Spacer(),
                              if (extraTranslations.length > 1)
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _showAllExtraTranslations = !_showAllExtraTranslations;
                                      });
                                    },
                                    child: Text(_showAllExtraTranslations ? "Hide" : "Show all")),
                            ],
                          ),
                          ...List.generate(
                            _showAllExtraTranslations ? extraTranslations.length : 1,
                            (index) {
                              var translation = extraTranslations[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(translation.label, style: Theme.of(context).textTheme.titleSmall),
                                        const SizedBox(height: 8),
                                        ...translation.content.map((e) => FilterChip(
                                              label: Text(e),
                                              onSelected: (bool value) {
                                                _onPick(e);
                                              },
                                            )),
                                      ],
                                    ),
                                    const Spacer(),
                                    FilterChip(
                                      label: Text(translation.type),
                                      onSelected: (value) {},
                                      selected: true,
                                      showCheckmark: false,
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _translate(String value) async {
    context.read<TranslateCubit>().updateText(value);
    context.read<TranslateCubit>().translate();
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );
    setState(() {
      _showAllExtraTranslations = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _sourceController = TextEditingController();
    _targetController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _sourceController.dispose();
    _targetController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onCopy() {
    if (_targetController.text.isEmpty) {
      return;
    }
    Clipboard.setData(ClipboardData(text: _targetController.text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
  }

  void _onDelete() {
    _sourceController.clear();
    _targetController.clear();
    context.read<TranslateCubit>().updateText("");
    _translate("");
  }

  void _onSwitch() {
    context.read<TranslateCubit>().swapLanguages();
    _sourceController.text = _targetController.text;
    _translate(_sourceController.text);
  }

  void _onPick(String translation) {
    _sourceController.text = translation;
    _translate(_sourceController.text);
  }
}
