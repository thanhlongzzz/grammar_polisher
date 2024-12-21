part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(false) bool isLoading,
    @Default(null) Failure? failure,
    @Default(null) Result? result,
  }) = _HomeState;
}
