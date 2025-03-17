import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/translate_snapshot.dart';
import '../../../data/repositories/global_repository.dart';

part 'generated/translate_cubit.freezed.dart';

part 'translate_state.dart';

class TranslateCubit extends Cubit<TranslateState> {
  late final GlobalRepository _globalRepository;

  TranslateCubit({
    required GlobalRepository globalRepository,
  })  : _globalRepository = globalRepository,
        super(const TranslateState());

  void translate() async {
    emit(state.copyWith(isLoading: true));

    final result = await _globalRepository.translate(
      text: state.text,
      from: state.sourceLanguage,
      to: state.targetLanguage,
    );

    result.fold(
      (error) => emit(state.copyWith(errorMessage: "Something went wrong. Please try again.", isLoading: false)),
      (snapshot) => emit(state.copyWith(translateSnapshot: snapshot, isLoading: false)),
    );
  }

  void updateText(String text) {
    emit(state.copyWith(text: text));
  }

  void swapLanguages() {
    emit(state.copyWith(
      sourceLanguage: state.targetLanguage,
      targetLanguage: state.sourceLanguage,
    ));
  }
}
