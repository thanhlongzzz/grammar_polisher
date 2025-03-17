part of 'translate_cubit.dart';

@freezed
class TranslateState with _$TranslateState {
  const factory TranslateState({
    TranslateSnapshot? translateSnapshot,
    String? errorMessage,
    @Default(false) bool isLoading,
    @Default('en') String sourceLanguage,
    @Default('vn') String targetLanguage,
    @Default('') String text,
  }) = _TranslateState;
}